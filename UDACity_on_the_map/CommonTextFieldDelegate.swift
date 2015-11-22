//
//  CommonTextFieldDelegate.swift
//  UDACity_on_the_map
//
//  Created by jason on 17/11/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit



class CommonTextFieldDelegate: NSObject, UITextFieldDelegate {
 
    //Callback method when enter is pressed => end editing the textfield in this case.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }


    static func sharedInstance() -> CommonTextFieldDelegate{
        struct Singleton {
            static var sharedInstance = CommonTextFieldDelegate()
        }

        return Singleton.sharedInstance
    }
}
