//
//  ParseMapData.swift
//  UDACity_on_the_map
//
//  Created by jason on 01/11/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import MapKit

extension ParseAPIClient {
    
    struct StudentMapData {
        var createdAt   : String
        var firstName   : String
        var lastName    : String
        var latitude    : Double
        var longitude   : Double
        var mapString   : String
        var mediaURL    : String
        var objectId    : String
        var uniqueKey   : String
        var updatedAt   : String
    }
    
    static func createPinAnnotation(with student_dict : NSDictionary) -> StudentMapData {
        let student_data : StudentMapData = StudentMapData(createdAt: student_dict[ParseAPIConstants.Student.createdAt]! as! String,
            firstName   : student_dict[ParseAPIConstants.Student.firstName]! as! String,
            lastName    : student_dict[ParseAPIConstants.Student.lastName]! as! String,
            latitude    : student_dict[ParseAPIConstants.Student.latitude]! as! Double,
            longitude   : student_dict[ParseAPIConstants.Student.longitude]! as! Double,
            mapString   : student_dict[ParseAPIConstants.Student.mapString]! as! String,
            mediaURL    : student_dict[ParseAPIConstants.Student.mediaURL]! as! String,
            objectId    : student_dict[ParseAPIConstants.Student.objectId]! as! String,
            uniqueKey   : student_dict[ParseAPIConstants.Student.uniqueKey]! as! String,
            updatedAt   : student_dict[ParseAPIConstants.Student.updatedAt]! as! String)
        
        return student_data
    }
}