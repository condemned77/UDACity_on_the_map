//
//  LoginViewController.swift
//  UDACity_on_the_map
//
//  Created by jason on 25/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    let udacityClient : UDACityClient = UDACityClient()


    override func viewDidLoad() {
//        self.applyGradientToBackground()
    }
    


    @IBAction func loginButtonTouchUpInside(sender: UIButton) {
        self.udacityClient.password = self.passwordTextField.text
        self.udacityClient.userName = self.emailTextField.text
        self.udacityClient.getSessionID()
    }

    func applyGradientToBackground() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.orangeColor().CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)

    }
}