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
//import Dotzu

class AutoVPNDNSResolver: DNSResolverProtocol {

    public weak var delegate: DNSResolverDelegate?

    public func resolve(session: DNSSession) {
        let googleIP = IPAddress(fromString: "61.91.161.217")!
        
        
        for query in session.requestMessage.queries {
            if !query.name.contains("icloud.com") && !query.name.contains("apple.com") {
                log.debug("AutoVPNDNSResolver query:\(query.name)")
            }

            if query.name.contains("google") {
                
                if let answer = buildDNSAnswer(session: session, ip: googleIP) {
                    delegate?.didReceive(rawResponse: answer.payload)
                }
            }
        }
    }

    private func buildDNSAnswer(session: DNSSession, ip: IPAddress) -> DNSMessage?{
        log.info("buildDNSAnswer")
//    
//        let udpParser = UDPProtocolParser()
//        udpParser.sourcePort = Port(portInNetworkOrder: 53)
//        // swiftlint:disable:next force_cast
//        udpParser.destinationPort = (session.requestIPPacket!.protocolParser as! UDPProtocolParser).sourcePort
        let response = DNSMessage()
        response.transactionID = session.requestMessage.transactionID
        response.messageType = .response
        response.recursionAvailable = true
        // since we only support ipv4 as of now, it must be an answer of type A
        response.answers.append(DNSResource.ARecord(session.requestMessage.queries[0].name, TTL: UInt32(Opt.DNSFakeIPTTL), address: ip))
        session.expireAt = Date().addingTimeInterval(Double(Opt.DNSFakeIPTTL))
        guard response.buildMessage() else {
            log.error("Failed to build DNS response.")
            return nil
        }
        return response
        
//        udpParser.payload = response.payload
//
//        let ipPacket = IPPacket()
//        ipPacket.sourceAddress = IPAddress(fromString: "198.18.0.1")!
//        ipPacket.destinationAddress = session.requestIPPacket!.sourceAddress
//        ipPacket.protocolParser = udpParser
//        ipPacket.transportProtocol = .udp
//        ipPacket.buildPacket()
//        
//        return ipPacket
    }
    
    public func stop() {

    }
}
