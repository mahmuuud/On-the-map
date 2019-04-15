//
//  UdacityApiPostSessionRequest.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/13/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation

struct PostSessionRequest:Codable {
    var udacity:[String:String]
    var username:String
    var password:String
}
