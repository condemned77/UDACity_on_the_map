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

    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    static func escapedParameters(parameters: [String : AnyObject]) -> String {
        
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
    
    
    /*This method presents and alertview with the passed message from a view controller, also passed as argument.*/
    static func showAlertView(withMessage errorMessage : String, fromViewController vc : UIViewController, withCompletionHandler ch: (() -> Void)?) {
        let alertController = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        if ActivityIndicator.sharedInstance.isShowingOnViewController(vc) {
            ActivityIndicator.sharedInstance.dismissActivityIndicator(fromViewController: vc)
        }
        dispatch_async(dispatch_get_main_queue(), {
            vc.presentViewController(alertController, animated: true, completion: ch)
        })
    }
    
    
    static let AppColorBlue : UIColor = UIColor(colorLiteralRed: 0.0, green: 0.478431373, blue: 1, alpha: 1.0)
    static let AppColorGrey : UIColor = UIColor(colorLiteralRed: 0.921568627, green: 0.925490196, blue: 0.945098039, alpha: 1.0)
}