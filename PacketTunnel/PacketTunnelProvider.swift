//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by Alex Chan on 2017/2/15.
//  Copyright © 2017年 sunset. All rights reserved.
//

import NetworkExtension
import NEKit
import CocoaLumberjackSwift
import Resolver

private let kProxyServer = "192.168.1.22"
private let kProxyPort = 52041

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    var server: GCDHTTPProxyServer!
    var interface: TUNInterface!
    
    override init() {
        super.init()
        
        DDLog.add(DDASLLogger.sharedInstance()) // ASL = Apple System Logs
        DDLog.add(DDTTYLogger.sharedInstance()) // TTY = Xcode console
    }
    
    deinit {
        
        DDLog.removeAllLoggers()
    }
    
    open class DebugObserverFactory2: ObserverFactory {
        public override init() {}
        
        override open func getObserverForProxyServer(_ server: ProxyServer) -> Observer<ProxyServerEvent>? {
            return DebugProxyServerObserver2()
        }
    }
    
    open class DebugProxyServerObserver2: Observer<ProxyServerEvent> {

        override open func signal(_ event: ProxyServerEvent) {
//            let mainVC = (UIApplication.shared.keyWindow!.rootViewController as! UINavigationController).topViewController as! MainTableViewController
            DDLogInfo("DebugProxyServerObserver2\(event)")
            switch event {
            case .started:
//                mainVC.status = .CONNECTED
                DDLogInfo("\(event)")
            case .stopped, .tunnelClosed:
//                mainVC.status = .DISCONNECTED
                DDLogInfo("\(event)")
            default: break
                
            }
        }
    }
    
    func getNetworkSetings() -> NEPacketTunnelNetworkSettings{
        // the `tunnelRemoteAddress` is meaningless because we are not creating a tunnel.
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
        networkSettings.mtu = 1500
        
        let ipv4Settings = NEIPv4Settings(addresses: ["192.169.89.1"], subnetMasks: ["255.255.255.0"])
      
            ipv4Settings.includedRoutes = [NEIPv4Route.default()]
            ipv4Settings.excludedRoutes = [
                NEIPv4Route(destinationAddress: "10.0.0.0", subnetMask: "255.0.0.0"),
                NEIPv4Route(destinationAddress: "100.64.0.0", subnetMask: "255.192.0.0"),
                NEIPv4Route(destinationAddress: "127.0.0.0", subnetMask: "255.0.0.0"),
                NEIPv4Route(destinationAddress: "169.254.0.0", subnetMask: "255.255.0.0"),
                NEIPv4Route(destinationAddress: "172.16.0.0", subnetMask: "255.240.0.0"),
//                NEIPv4Route(destinationAddress: "192.168.0.0", subnetMask: "255.255.0.0"),
            ]
        
        networkSettings.iPv4Settings = ipv4Settings
        
        let proxySettings = NEProxySettings()
        //        proxySettings.autoProxyConfigurationEnabled = true
        //        proxySettings.proxyAutoConfigurationJavaScript = "function FindProxyForURL(url, host) {return \"SOCKS 127.0.0.1:\(proxyPort)\";}"
        proxySettings.httpEnabled = true
        proxySettings.httpServer = NEProxyServer(address: "127.0.0.1", port: 9090)
        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = NEProxyServer(address: "127.0.0.1", port: 9090)
        proxySettings.excludeSimpleHostnames = true
        // This will match all domains
        proxySettings.matchDomains = [""]
        networkSettings.proxySettings = proxySettings
        
        // the 198.18.0.0/15 is reserved for benchmark.
      
            let DNSSettings = NEDNSSettings(servers: ["198.18.0.1"])
            DNSSettings.matchDomains = [""]
            DNSSettings.matchDomainsNoSearch = false
            networkSettings.dnsSettings = DNSSettings
       
        
        return networkSettings

    }

    override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {

        
        
        let directAdapterFactory = DirectAdapterFactory()
        let httpAdapterFactory = HTTPAdapterFactory(serverHost: kProxyServer, serverPort: kProxyPort, auth: nil)
        let chinaRule =  CountryRule(countryCode: "CN", match: true, adapterFactory: directAdapterFactory)
        let allRule = AllRule(adapterFactory: httpAdapterFactory)
        
        let manager = RuleManager(fromRules: [chinaRule, allRule], appendDirect: true)
        RuleManager.currentManager = manager
        
        ObserverFactory.currentFactory = DebugObserverFactory2()
        
        server = GCDHTTPProxyServer(address: IPAddress(fromString: "127.0.0.1"), port: Port(port: 9090))
        
        try! server.start()
        
        RawSocketFactory.TunnelProvider = self
        
 
        
        completionHandler(nil)

        self.setTunnelNetworkSettings(getNetworkSetings(), completionHandler: {
            error in
            guard error == nil else {
                DDLogError("Encountered an error setting up the network: \(error!)")
                completionHandler(error)
                return
            }
            
            
            
            self.interface = TUNInterface(packetFlow: self.packetFlow)
            
            let fakeIPPool = try! IPPool(range: IPRange(startIP: IPAddress(fromString: "172.169.1.0")!, endIP: IPAddress(fromString: "172.169.255.0")!))
            
            let dnsServer = DNSServer(address: IPAddress(fromString: "172.169.0.1")!, port: Port(port: 53), fakeIPPool: fakeIPPool)
            let resolver = UDPDNSResolver(address: IPAddress(fromString: "114.114.114.114")!, port: Port(port: 53))
            dnsServer.registerResolver(resolver)
            DNSServer.currentServer = dnsServer
            
            let tcpStack = TCPStack.stack
            tcpStack.proxyServer = self.server
            
            self.interface.register(stack: dnsServer)
            self.interface.register(stack: UDPDirectStack())
            self.interface.register(stack: tcpStack)
            

            
            self.interface.start()
        })
        



    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        
        interface.stop()
        interface = nil
        DNSServer.currentServer = nil
        
        server.stop()
        server = nil
  
        RawSocketFactory.TunnelProvider = nil
        
        
        
        completionHandler()
        
        // For unknown reason, the extension will be running for several extra seconds, which prevents us from starting another configuration immediately. So we crash the extension now.
        // I do not find any consequences.
        exit(EXIT_SUCCESS)
        
    }
    

}
