//
//  ParseAPIConstants.swift
//  UDACity_on_the_map
//
//  Created by jason on 31/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation

class ParseAPIConstants {
    static let APPLICATION_ID           = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let REST_API_Key             = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"


    struct URLs {
        static let STUDENTLOCATION      = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct Student {
        static let firstName            = "firstName"
        static let lastName             = "lastName"
        static let createdAt            = "createdAt"
        static let latitude             = "latitude"
        static let longitude            = "longitude"
        static let mapString            = "mapString"
        static let mediaURL             = "mediaURL"
        static let objectId             = "objectId"
        static let uniqueKey            = "uniqueKey"
        static let updatedAt            = "updatedAt"
    }
}