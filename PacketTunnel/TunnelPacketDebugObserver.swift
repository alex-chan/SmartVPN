//
//  DebugObserver.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/5/1.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import NEKit

open class SmartVPNDebugObserverFactory: ObserverFactory {
    public override init() {}
    
    override open func getObserverForTunnel(_ tunnel: Tunnel) -> Observer<TunnelEvent>? {
        return DebugTunnelObserver()
    }
    
    override open func getObserverForAdapterSocket(_ socket: AdapterSocket) -> Observer<AdapterSocketEvent>? {
        return DebugAdapterSocketObserver()
    }
    
    override open func getObserverForProxySocket(_ socket: ProxySocket) -> Observer<ProxySocketEvent>? {
        return DebugProxySocketObserver()
    }
    
    override open func getObserverForProxyServer(_ server: ProxyServer) -> Observer<ProxyServerEvent>? {
        return DebugProxyServerObserver ()
    }
    
    override open func getObserverForRuleManager(_ manager: RuleManager) -> Observer<RuleMatchEvent>? {
        return DebugRuleManagerObserver()
    }
}

open class DebugProxyServerObserver: Observer<ProxyServerEvent> {
    
    override open func signal(_ event: ProxyServerEvent) {
        log.info("DebugProxyServerObserver\(event)")
    }
}


open class DebugRuleManagerObserver: Observer<RuleMatchEvent> {
    override open func signal(_ event: RuleMatchEvent) {
        log.info("DebugRuleManagerObserver:\(event)")
    }
}


open class DebugTunnelObserver: Observer<TunnelEvent> {
    override open func signal(_ event: TunnelEvent) {
        log.info("DebugTunnelObserver:\(event)")
    }
}

open class DebugProxySocketObserver: Observer<ProxySocketEvent> {
    override open func signal(_ event: ProxySocketEvent) {
        log.info("DebugProxySocketObserver:\(event)")
    }
}

open class DebugAdapterSocketObserver: Observer<AdapterSocketEvent> {
    override open func signal(_ event: AdapterSocketEvent) {
        log.info("DebugAdapterSocketObserver:\(event)")
    }
}
