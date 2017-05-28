//
//  SmartVPNError.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/5/28.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorCode: Mappable {
    
    var code: Int!
    var message: String!

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        code            <- map["code"]
        message         <- map["message"]

    }
}

