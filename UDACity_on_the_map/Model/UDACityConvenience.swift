//
//  UDACityConvenience.swift
//  UDACity_on_the_map
//
//  Created by Michael on 28/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation

extension UDACityClient {
//convenience method for requesting the UDACity sessionID. Relies user name and password being stored within respective properties.
    func getSessionID() {
        
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
            return
        }

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}