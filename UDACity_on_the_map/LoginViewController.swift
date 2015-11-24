//
//  LoginViewController.swift
//  UDACity_on_the_map
//
//  Created by jason on 25/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    let udacityClient : UDACityClient = UDACityClient.sharedInstance()


    override func viewDidLoad() {
//        self.applyGradientToBackground()
        self.passwordTextField.delegate = CommonTextFieldDelegate.sharedInstance()
        self.emailTextField.delegate    = CommonTextFieldDelegate.sharedInstance()
    }
    

    /*Starts the login process by reading the user credentials from the corresponding
    text fields. User email and password are in properties.*/
    @IBAction func loginButtonTouchUpInside(sender: UIButton) {
        self.udacityClient.password = self.passwordTextField.text
        self.udacityClient.userName = self.emailTextField.text
        if self.udacityClient.password == "" {
            Helpers.showAlertView(withMessage: "You didn't enter a password!", fromViewController: self, withCompletionHandler: nil)
        }

        else if self.udacityClient.userName == "" {
            Helpers.showAlertView(withMessage: "You didn't enter a user name!", fromViewController: self, withCompletionHandler: nil)
        }
        else {
            self.startLoginProcess()
        }
    }

    /*This methods starts the login process by telling the UDACity client to login.
    When the login is sucessfully completed, the map is loaded. Otherwise and alert view will
    show an error.*/
    func startLoginProcess() {
        ActivityIndicator.sharedInstance.showActivityIndicator(fromViewController: self)
        self.udacityClient.loginToUDACity() {
            (success, errorString) in

            if success {
                self.completeLogin()
            } else {
                //show alert view
                Helpers.showAlertView(withMessage: errorString!, fromViewController: self, withCompletionHandler: nil)
            }
            ActivityIndicator.sharedInstance.dismissActivityIndicator(fromViewController: self)
        }
    }



    //Present the tabbar controller when login was successful.
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabbarController") as! MapTabbarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    
    /*IBAction method which opens the UDACity website in safari.*/
    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        let udacityURL : NSURL = NSURL(string: "https://udacity.com")!
        UIApplication.sharedApplication().openURL(udacityURL)
    }
}