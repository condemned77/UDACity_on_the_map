//
//  UDACityConstants.swift
//  UDACity_on_the_map
//
//  Created by Michael on 28/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation

extension UDACityClient {

    struct Constants {
        static let FACEBOOK_APP_ID : String = "365362206864879"

    }

    struct URLs {
        static let SESSION_ID_URL : String  = "https://www.udacity.com/api/session"
        static let USER_DATA_URL : String   = "https://www.udacity.com/api/users"
    }
    
    struct Methods {
        static let DELETE   : String = "DELETE"
        static let POST     : String = "POST"
    }
    
    struct Requests{
        static let USERNAME : String = "username"
        static let PASSWORD : String = "password"
    }

}