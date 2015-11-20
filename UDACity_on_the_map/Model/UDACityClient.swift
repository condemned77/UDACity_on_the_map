//
//  UDACityClient.swift
//  UDACity_on_the_map
//
//  Created by Michael on 28/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
class UDACityClient {
    var userName : String?
    var password : String?
    var sessionID: String?

    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {

        var urlVars = [String]()

        for (key, value) in parameters {

            /* Make sure that it is a string value */
            let stringValue = "\(value)"

            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]

        }

        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }



    func taskForPOSTMethod(urlString : String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }

        /* 4. Make the request */
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: error)
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var loginError : NSError? = nil
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    loginError = NSError(domain: "wrong user name or password", code: response.statusCode, userInfo: nil)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    loginError = NSError(domain: "Your request returned an invalid response", code: -1, userInfo: nil)
                } else {
                    print("An unknown error occurred")
                    loginError = NSError(domain: "An unknown error occurred", code: -1, userInfo: nil)
                }
                completionHandler(result: response, error: loginError)
                return
            }
            let newData = data?.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            /* GUARD: Was there any data returned? */
            guard let data = newData else {
                print("No data was returned by the request!")
                return
            }

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            UDACityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }

        /* 7. Start the request */
        task.start()

        return task
    }

    // MARK: Shared Instance

    class func sharedInstance() -> UDACityClient {

        struct Singleton {
            static var sharedInstance = UDACityClient()
        }

        return Singleton.sharedInstance
    }


}