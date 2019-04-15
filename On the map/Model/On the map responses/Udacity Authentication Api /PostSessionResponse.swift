//
//  UdacityApiResponse.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/13/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation

struct Account:Codable {
    var registered:Bool?
    var key:String?
}

struct Session:Codable {
    var id:String?
    var expiration:String?
}

struct PostSessionResponse:Codable{
    var account:Account
    var session:Session
}
