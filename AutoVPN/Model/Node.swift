//
//  Nodes.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/5/28.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import ObjectMapper


enum AdapterType {
    case ss
    case ssr
}

class Node: Mappable {
    
    var adapter: AdapterType!
    var serverAddr: String!
    var serverPort: Int!
    var key: String!
    var method: String!

    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        adapter    <- map["adapter"]
        serverAddr         <- map["server"]
        serverPort      <- map["port"]
        key       <- map["key"]
        method  <- map["method"]
    }
}



class NodeResponse: Mappable {
    var error: ErrorCode!
    var result: [Node]!

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        error    <- map["error"]
        result         <- map["result"]
    }
    
}
