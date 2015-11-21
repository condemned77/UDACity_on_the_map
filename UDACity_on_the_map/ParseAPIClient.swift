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

    static func requestStudentLocations(completionHandler: (studentLocations : [ParseAPIClient.StudentMapData]!, error: NSError?) -> Void) {
        deleteStudentData()
        POSTLocationRequest() {
            (json_data, error) in
            guard let json_dict = json_data as? NSDictionary else {print("couldn't cast json data"); return}
            guard let student_list = json_dict["results"] as? [NSDictionary] else {print("couldn't find student data"); return}


            for student in student_list {
                let student_struct : ParseAPIClient.StudentMapData = ParseAPIClient.createPinAnnotation(with: student)
                addStudentData(student_struct)
            }
            completionHandler(studentLocations: ParseAPIClient.studentLocations, error: nil)
        }

    }

    
    static func deleteStudentData() {
        studentLocations = []
    }
    
    static func addStudentData(student_struct : StudentMapData) {
        studentLocations.append(student_struct)
    }

    /*Convenience method that requests the student location data.
      The student location data is passed to the completion handler argument, which
      has to process the received data.
    */
    static func POSTLocationRequest(completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: ParseAPIConstants.URLs.STUDENTLOCATION)!)
        request.addValue(ParseAPIConstants.APPLICATION_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPIConstants.REST_API_Key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // TODO: Handle error...
                return
            }
            print("data response: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
            Helpers.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
        }
        
        task.start()
    }
}