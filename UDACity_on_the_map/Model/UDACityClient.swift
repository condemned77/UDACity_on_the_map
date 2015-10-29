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


//    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
//
//        /* 1. Set the parameters */
//        var mutableParameters = parameters
////        mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey
//
//        /* 2/3. Build the URL and configure the request */
//        let urlString = Constants.BaseURLSecure + method + UDACityClient.escapedParameters(mutableParameters)
//        let url = NSURL(string: urlString)!
//        let request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        do {
//            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
//        }
//
//        /* 4. Make the request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
//                } else if let response = response {
//                    print("Your request returned an invalid response! Response: \(response)!")
//                } else {
//                    print("Your request returned an invalid response!")
//                }
//                return
//            }
//
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//
//            /* 5/6. Parse the data and use the data (happens in completion handler) */
//            TMDBClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
//        }
//
//        /* 7. Start the request */
//        task.resume()
//
//        return task
//    }

    // MARK: Shared Instance

    class func sharedInstance() -> UDACityClient {

        struct Singleton {
            static var sharedInstance = UDACityClient()
        }

        return Singleton.sharedInstance
    }


}