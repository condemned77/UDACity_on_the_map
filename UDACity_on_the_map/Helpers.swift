//
//  Helpers.swift
//  UDACity_on_the_map
//
//  Created by jason on 01/11/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit

struct Helpers {
    /* Helper: Given raw JSON, the method provides a usable Foundation object by passing it to the 
    completion handler.*/
    static func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }

    /*This method presents and alertview with the passed message from a view controller, also passed as argument.*/
    static func showAlertView(withMessage errorMessage : String, fromViewController vc : UIViewController) {
        let alertController = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        dispatch_async(dispatch_get_main_queue(), {
            vc.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}