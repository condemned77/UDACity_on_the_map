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
    /* Helper: Given raw JSON, return a usable Foundation object */
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
}