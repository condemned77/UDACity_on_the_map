//
//  InformationPostingViewController.swift
//  UDACity_on_the_map
//
//  Created by jason on 11/11/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit

class InformationPostingViewController : UIViewController, UITextFieldDelegate {



    @IBOutlet weak var whereAreYouLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var locationTextField : UITextField!
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        self.locationTextField.delegate = CommonTextFieldDelegate.sharedInstance()
    }
    
    @IBAction func findOnMapButtonPressed(sender: UIButton) {
        //todo search for location and set it to the map.
        //show mapview
        //hide labels
        self.hideLabels()
        //change texts
        
    }
    
    
    func hideLabels() {
        self.whereAreYouLabel.hidden    = true
        self.studyingLabel.hidden       = true
        self.todayLabel.hidden          = true
    }
}