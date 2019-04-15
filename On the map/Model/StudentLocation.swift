//
//  StudentLocation.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/10/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
struct StudentLocation:Codable {
    //optionals because some students pushed nil data to the server
    var objectId:String?
    var uniqueKey:String?
    var firstName:String?
    var lastName:String?
    var mapString:String?
    var mediaUrl:String?
    var latitude:Double?
    var longitude:Double?
    var createdAt:String?
    var updatedAt:String?
    
    enum CodingKeys:String, CodingKey {
        case objectId
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaUrl="mediaURL"
        case latitude
        case longitude
        case createdAt
        case updatedAt
    }
}
