//
//  MyDNSServer.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/4/25.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import NEKit
//import SwiftyBeaver
import Dotzu

class AutoVPNDNSResolver: DNSResolverProtocol {

    public weak var delegate: DNSResolverDelegate?

    public func resolve(session: DNSSession) {
        let googleIP = "61.91.161.217"
        
        Logger.info("AutoVPNDNSResolver resolve")
        
        for query in session.requestMessage.queries {
            log.debug("DNS Query:\(query.name)")
            if query.name.contains("google") {
                delegate?.didReceive(rawResponse: googleIP.data(using: .utf8)!)
            }
        }
    }

    public func stop() {

    }
}
