//
//  ActivityIndicator.swift
//  UDACity_on_the_map
//
//  Created by jason on 24/11/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    static let sharedInstance = ActivityIndicator()
    let backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
    let activityIndicator = UIActivityIndicatorView()
    var presentingViewController : UIViewController?
    
    func isShowingOnViewController(viewcontroller: UIViewController) -> Bool{
        if let vc = self.presentingViewController {
            return vc.isEqual(viewcontroller)
        } else {
            return false
        }
    }
    
    /*Convenience method for displaying an activity indicator from any view controller.
    The activity indicator is a shared instance.*/
    func showActivityIndicator(fromViewController vc : UIViewController) {
        self.presentingViewController = vc
        print("starting the activity indicator")
        activityIndicator.center = backgroundView.center
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20)
        backgroundView.addSubview(activityIndicator)
        backgroundView.bringSubviewToFront(activityIndicator)
        dispatch_async(dispatch_get_main_queue(), {
            vc.view.addSubview(self.backgroundView)
            vc.view.bringSubviewToFront(self.backgroundView)
        })
        self.activityIndicator.startAnimating()
    }
    
    
    /*Convenience method for dismissing the activity indicator of the sharedInstance.*/
    func dismissActivityIndicator(fromViewController vc : UIViewController) {
        print("stoping the activity indicator")
        dispatch_async(dispatch_get_main_queue(), {
            self.backgroundView.removeFromSuperview()
            self.activityIndicator.stopAnimating()
        })
    }
}