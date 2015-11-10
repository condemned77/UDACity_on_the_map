//
//  TabbarController.swift
//  UDACity_on_the_map
//
//  Created by jason on 04/11/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit

class MapTabbarController : UITabBarController {
    
    var studentLocations : [ParseAPIClient.StudentMapData] = []

    func requestStudentLocation(completionHandler: (studentLocations : [ParseAPIClient.StudentMapData]!, error: NSError?) -> Void) {


        ParseAPIClient.requestStudentLocation() {
            (json_data, error) in
            guard let json_dict = json_data as? NSDictionary else {print("couldn't cast json data"); return}
            guard let student_list = json_dict["results"] as? [NSDictionary] else {print("couldn't find student data"); return}


            for student in student_list {
                let student_struct : ParseAPIClient.StudentMapData = ParseAPIClient.createPinAnnotation(with: student)
                self.studentLocations.append(student_struct)
            }
            completionHandler(studentLocations: self.studentLocations, error: nil)
        }

    }

    func addStudentLocation(studentLocation : ParseAPIClient.StudentMapData) {
        self.studentLocations.append(studentLocation)
    }
}