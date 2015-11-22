//
//  UDACityConvenience.swift
//  UDACity_on_the_map
//
//  Created by Michael on 28/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation

extension NSURLSessionTask {
    func start() {
        self.resume()
    }
}

extension UDACityClient {
    
    
    func loginToUDACity(completionHandler : (success : Bool, errorString : String?) -> Void) {
        self.getSessionID(completionHandler)
    }
    
    func logoutFromUDACitySession(completionHandler: (success : Bool, error : NSError?) -> Void) {
        self.deleteUDACitySession(completionHandler)
    }
    
//convenience method for requesting the UDACity sessionID. Relies user name and password being stored within respective properties.
    func getSessionID(completionHandler : (success : Bool, errorString : String?) -> Void) {
        
        let body_params = ["udacity": [
            Requests.USERNAME : "\(self.userName!)",
            Requests.PASSWORD : "\(self.password!)"]
        ]
        let request = NSMutableURLRequest(URL: NSURL(string: URLs.SESSION_ID_URL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body_params, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("JSON data couldn't be serialized into http body")
        }

        let task = self.taskForPOSTMethod(URLs.SESSION_ID_URL, jsonBody: body_params) {
            (result, error) in
            guard error == nil else {completionHandler(success: false, errorString: "error: \(error!.domain) \n with error code: \(error!.code)"); return}
            if let result_dict : NSDictionary = result as? NSDictionary {
                print(result_dict)
                if let session_value_dict = result_dict["session"] as? NSDictionary {
                    if let session_id = session_value_dict["id"] as? String {
                        self.sessionID = session_id
                    }
                }
                
                if let account_data = result_dict["account"] as? NSDictionary {
                    if let accountID = account_data["key"] as? String{
                        self.udaCityAccountID = accountID
                    }
                }
                self.getUserData(withUserID: self.udaCityAccountID!)
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "The HTTP response couldn't be read.")
            }
        }
        task.start()
    }
    
    func getUserData(withUserID userID : String) {
        let request = NSMutableURLRequest(URL: NSURL(string: URLs.USER_DATA_URL + "/\(userID)")!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            Helpers.parseJSONWithCompletionHandler(newData) {
                result, error in
                if let json = result as? Dictionary<String, AnyObject!>  {
                    if let userData = json["user"] as? Dictionary<String, AnyObject> {
                        self.firstName  = userData["first_name"] as? String
                        self.lastName   = userData["last_name"] as? String

                    }
                }
            }
            
        }
        
        task.resume()
    }
}