//
//  ViewController.swift
//  AutoVPN-mac
//
//  Created by Alex Chan on 2017/2/15.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Cocoa
import NetworkExtension

import NEKit
import CocoaLumberjackSwift

class ViewController: NSViewController {
    var vpnManger: NETunnelProviderManager!

    @IBOutlet weak var mainButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
 
        
        NETunnelProviderManager.loadAllFromPreferences(completionHandler: {
            (managers, error) in
            
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
//                manager.isOnDemandEnabled = true
//                let quickStartRule = NEOnDemandRuleEvaluateConnection()
//                quickStartRule.connectionRules = [NEEvaluateConnectionRule(matchDomains: ["connect.potatso.com"], andAction: NEEvaluateConnectionRuleAction.connectIfNeeded)]
//                manager.onDemandRules = [quickStartRule]
                manager.saveToPreferences(completionHandler: { (error) -> Void in
                    if let error = error {
                        DDLogInfo("\(error)")
                    }else{
                        manager.loadFromPreferences(completionHandler: { (error) -> Void in
                            if let error = error {
                                 DDLogInfo("\(error)")
                            }else{
                                DDLogInfo("OK")
                                self.vpnManger = manager
                            }
                        })
                    }
                })
                
            }
        })
        
        
    }
    
    fileprivate func createProviderManager() -> NETunnelProviderManager {
        let manager = NETunnelProviderManager()
        manager.protocolConfiguration = NETunnelProviderProtocol()
        return manager
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startStopVPN(_ sender: Any) {
         try! vpnManger.connection.startVPNTunnel()
    }

}

