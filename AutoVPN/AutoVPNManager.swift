//
//  AutoVPNManager.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/2/21.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import NetworkExtension
import CocoaLumberjackSwift

enum ProxyServerStatus: Int, CustomStringConvertible {
    case disconnected=1, connecting=2, connected=3, disconnecting=5
    var description: String {
        switch self {
        case .disconnected:
            return "Disconnected".localized()
        case .connecting:
            return "Connecting...".localized()
        case .connected:
            return "Connected".localized()
        case .disconnecting:
            return "Disconnecting...".localized()
        }
    }
}

protocol AutoVPNManagerDelegate {
    func vpnStatusDidUpdated(status: ProxyServerStatus)
}

class AutoVPNManager {
    
    var observerAdded: Bool = false
    


    var status = ProxyServerStatus.disconnected
    
    var delegate: AutoVPNManagerDelegate?

    var vpnManager: NETunnelProviderManager!

    func updateVPNStatus(_ manager: NEVPNManager) {
        status = ProxyServerStatus(rawValue: manager.connection.status.rawValue) ?? .disconnected
        DDLogVerbose("updateVPNStatus:\(status)")
        delegate?.vpnStatusDidUpdated(status: status)
    }
    
    func addVPNStatusObserver() {
        guard !observerAdded else{
            return
        }
        loadProviderManager { [unowned self] (manager) -> Void in
            if let manager = manager {
                self.observerAdded = true
                NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: manager.connection, queue: OperationQueue.main, using: { [unowned self] (notification) -> Void in
                    self.updateVPNStatus(manager)
                })
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func loadProviderManager(_ complete: @escaping (NETunnelProviderManager?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) -> Void in
            if let managers = managers {
                if managers.count > 0 {
                    let manager = managers[0]
                    complete(manager)
                    return
                }
            }
            complete(nil)
        }
    }
    
    fileprivate func loadOrCreateManager(completionHandler: @escaping (NETunnelProviderManager?, Error?) -> Void ){
        NETunnelProviderManager.loadAllFromPreferences(completionHandler: {
            (managers, error) in
            
            guard error == nil else{
                completionHandler(nil, error)
                return
            }
            
            if let managers = managers {
                
                
                let manager: NETunnelProviderManager
                if managers.count > 0 {
                    manager = managers[0]
                }else{
                    manager = self.createProviderManager()
                }
                manager.isEnabled = true
                manager.localizedDescription = "AutoVPN"
                manager.protocolConfiguration?.serverAddress = "127.0.0.1"
                //                manager.isOnDemandEnabled = false
                //                let quickStartRule = NEOnDemandRuleEvaluateConnection()
                //                quickStartRule.connectionRules = [NEEvaluateConnectionRule(matchDomains: ["connect.potatso.com"], andAction: NEEvaluateConnectionRuleAction.connectIfNeeded)]
                //                manager.onDemandRules = [quickStartRule]
                manager.saveToPreferences(completionHandler: { (error) -> Void in
                    if let error = error {
                        DDLogError("\(error)")
                        completionHandler(nil, error)
                    }else{
                        manager.loadFromPreferences(completionHandler: { (error) -> Void in
                            if let error = error {
                                DDLogError("\(error)")
                                completionHandler(nil, error)
                            }else{
                                DDLogInfo("Load vpn preference OK")
                                self.vpnManager = manager
                                completionHandler(manager, nil)
                            }
                        })
                    }
                })
                
            }
        })
    }
    
    
    fileprivate func createProviderManager() -> NETunnelProviderManager {
        //        let manager = NETunnelProviderManager()
        let manager = NETunnelProviderManager()
        manager.protocolConfiguration = NETunnelProviderProtocol()
        return manager
    }
    
    open func startStopVPN(completionHandler: @escaping (Error?)->Void )   {
        
        loadOrCreateManager(completionHandler: {
            (manager, error) in
            guard let manager = manager, error == nil else {
                 completionHandler(error)
                return
            }
            
            
            if manager.connection.status == .disconnected || manager.connection.status == .invalid {
                do{
                    try manager.connection.startVPNTunnel()
                }catch {
                    DDLogError("start VPNtunnel error:\(error)")
                }
                
            }else if manager.connection.status == .connected {
                manager.connection.stopVPNTunnel()
                
            }
            self.addVPNStatusObserver()
        })
        

    }

}
