//
//  Service.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/5/28.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import Moya

enum Service {
    case nodes
}


extension Service: TargetType {
    var baseURL: URL {
        return URL(string: kControlServer)!
    }
    
    var path: String {
        return "/service/nodes"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return "{}".utf8Encoded
    }
    
    var task: Task {
        return .request
    }
  
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
