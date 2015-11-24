//
//  ParseAPIClient.swift
//  UDACity_on_the_map
//
//  Created by jason on 31/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation

class ParseAPIClient: NSObject {

    static var studentLocations : [StudentMapData] = []

    /*Requesting the student locations sends a post request to the ParseAPI. The method processes the student information gotten as
    response by building student structs and storing them into the static variable studentLocations.*/
    static func requestStudentLocations(completionHandler: (studentLocations : [ParseAPIClient.StudentMapData]!, error: NSError?) -> Void) {
        deleteStudentData()
        POSTLocationRequest() {
            (json_data, error) in
            guard error == nil else {
                completionHandler(studentLocations: nil, error: error)
                return
            }
            guard let json_dict = json_data as? NSDictionary else {print("couldn't cast json data"); return}
            if let error_string = json_dict["error"] as? String {
                let downloadError = NSError(domain: error_string, code: -1, userInfo: nil)
                completionHandler(studentLocations: nil, error: downloadError)
            }
            
            guard let student_list = json_dict["results"] as? [NSDictionary] else {
                print("couldn't find student data")
                let downloadError = NSError(domain: "Studentdata not found.", code: -1, userInfo: nil)
                completionHandler(studentLocations: nil, error: downloadError)
                return
            }

            for student in student_list {
                let student_struct : ParseAPIClient.StudentMapData = ParseAPIClient.StudentMapData(with: student)
                addStudentData(student_struct)
            }
            completionHandler(studentLocations: ParseAPIClient.studentLocations, error: nil)
        }
    }

    
    /*convenience method for clearing the currenlty stored student structs in the static variable studentLocations*/
    static func deleteStudentData() {
        studentLocations = []
    }
    
    /*convenience method for disguising the underlying data repository.*/
    static func addStudentData(student_struct : StudentMapData) {
        studentLocations.append(student_struct)
    }

    /*Convenience method that requests the student location data.
      The student location data is passed to the completion handler argument, which
      has to process the received data.
    */
    static func POSTLocationRequest(completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let params = [
//            "order" : "-updatedAd",
            "limit" : "100"
        ]
        
        let studentLocationURLString = ParseAPIConstants.URLs.STUDENTLOCATION + Helpers.escapedParameters(params)
        
        let request = NSMutableURLRequest(URL: NSURL(string: studentLocationURLString)!)
        request.addValue(ParseAPIConstants.APPLICATION_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPIConstants.REST_API_Key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("completionhandler of POSTLocationRequest")
            guard error == nil else {
                let requestError = NSError(domain: "Couldn't complete request. Please check your internet connection.", code: (error?.code)!, userInfo: nil)
                completionHandler(result: nil, error: requestError)
                return
            }
            print("data response: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
            Helpers.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
        }
        
        task.start()
    }
    
    /*Convenience method for posting student data to the ParseAPI servers. The method takes a student struct (see ParseAPIMapData.swift),
    and extracts the relevant information accordingly:
    1. student's first and last name
    2. a uniqueKey, which is supposed to be the Udacity account (user) id
    3. a map string, which corresponds to the location the student wants to set the pin on the map to
    4. media url, which corresponds to a URL added by the student (the URL will be displayed at the pin on the map)
    5. coordinates of the pin (longitude and latitude)*/
    static func addStudentLocationToParseAPI(studentStruct : StudentMapData, completionHanlder: (success : Bool, error : NSError?) -> Void) -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: ParseAPIConstants.URLs.STUDENTLOCATION)!)
        
        request.HTTPMethod = UDACityClient.Methods.POST
        
        request.addValue(ParseAPIConstants.APPLICATION_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPIConstants.REST_API_Key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(studentStruct)
        request.HTTPBody = "{\"uniqueKey\": \"\(studentStruct.uniqueKey!)\", \"firstName\": \"\(studentStruct.firstName!)\", \"lastName\": \"\(studentStruct.lastName!)\",\"mapString\": \"\(studentStruct.mapString!)\", \"mediaURL\": \"\(studentStruct.mediaURL!)\",\"latitude\": \(studentStruct.latitude!), \"longitude\": \(studentStruct.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard error == nil else{ // Handle error…
                let appError : NSError = NSError(domain: "couldn't post student location. Check your internet connection: \(error)", code: (error?.code)!, userInfo: nil)
                completionHanlder(success: false, error: appError)
                return
            }
            Helpers.parseJSONWithCompletionHandler(data!) {
                (result, error) in
                completionHanlder(success: true, error: nil)
            }
        }
        
        task.start()
    }
}