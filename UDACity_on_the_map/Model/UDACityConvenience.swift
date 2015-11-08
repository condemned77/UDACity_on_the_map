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
    
    
    func loginToUDACity(completionHanlder : (success : Bool, errorString : String?) -> Void) {
        self.getSessionID(completionHanlder)
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
        
            if let result_dict : NSDictionary = result as? NSDictionary {
                
                print(result_dict)
                if let session_value_dict = result_dict["session"] as? NSDictionary {
                    if let session_id = session_value_dict["id"] as? String {
                        self.sessionID = session_id
                        completionHandler(success: true, errorString: nil)
                    }
                }
            }
        }
        task.start()
    }
}



    