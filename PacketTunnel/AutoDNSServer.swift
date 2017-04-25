//
//  MyDNSServer.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/4/25.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation


class AutoVPNDNSServer: DNSResolverProtocol {
    
    public weak var delegate: DNSResolverDelegate?
    
    public init() {
        
    }
    
    public func resolve(session: DNSSession) {
        let googleIP = "61.91.161.217"
        
        if session.requestMessage.queries.first!.name.hasSuffix(".google.com") {
            delegate?.didReceive(rawResponse: googleIP.data(using: .utf8))
        }
    }
    
    public func stop() {
        
    }
}
