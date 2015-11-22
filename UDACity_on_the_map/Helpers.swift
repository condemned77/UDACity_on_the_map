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
    static func showAlertView(withMessage errorMessage : String, fromViewController vc : UIViewController, withCompletionHandler ch: (() -> Void)?) {
        let alertController = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        dispatch_async(dispatch_get_main_queue(), {
            vc.presentViewController(alertController, animated: true, completion: ch)
        })
    }
    
    
    /*Convenience method for displaying an activity indicator from any view controller.
    The activity indicator is a shared instance.*/
    static func showActivityIndicator(fromViewController vc : UIViewController) {
        let actInd = Helpers.sharedActivityIndicator()
        actInd.center = vc.view.center
        vc.view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    /*Convenience method for dismissing the activity indicator of the sharedInstance.*/

    static func dismissActivityIndicator(fromViewController vc : UIViewController) {
        let actInd = Helpers.sharedActivityIndicator()
        actInd.removeFromSuperview()
        actInd.stopAnimating()
    }
    
    /*singleton convenience method + setup of activity indicator properties.*/
    static var activityIndicator : UIActivityIndicatorView? = nil
    static func sharedActivityIndicator() -> UIActivityIndicatorView{
        
        if activityIndicator == nil {
            Helpers.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            Helpers.activityIndicator!.hidesWhenStopped = true
            Helpers.activityIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        }
        return Helpers.activityIndicator!
    }
    
    static let AppColorBlue : UIColor = UIColor(colorLiteralRed: 0.0, green: 0.478431373, blue: 1, alpha: 1.0)
    static let AppColorGrey : UIColor = UIColor(colorLiteralRed: 0.921568627, green: 0.925490196, blue: 0.945098039, alpha: 1.0)

}