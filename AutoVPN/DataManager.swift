//
//  DataManager.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/5/28.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import ReactiveSwift
import Moya
import ReactiveMoya
import MoyaObjectMapper

class DataManager {
    let shared = DataManager()
    
    let provider = ReactiveSwiftMoyaProvider<Service>()
    
    private init() {
        
    }
    
    func fetchNodes() {
        
        provider.request(.nodes)
            .map(to: NodeResponse.self).start {
                
        }
    }
    
    func fetchProxyModes() {
        
    }
    
    func fetchPurchaseModes() {
        
    }
    
    
}
