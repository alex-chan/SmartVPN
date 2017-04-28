//
//  MainTableViewController.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/2/15.
//  Copyright © 2017年 sunset. All rights reserved.
//

import UIKit

import NetworkExtension

import NEKit
import CocoaLumberjackSwift
import Localize_Swift
import Alamofire
import ToastSwiftFramework
import SwiftyJSON
import GoogleMobileAds

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var actionCell: UITableViewCell!
    @IBOutlet weak var statusLabel: UILabel!    
    @IBOutlet weak var bannerAd: GADBannerView!
    
    let manager = AutoVPNManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerAd.isHidden  = true
        
        bannerAd.adUnitID = kAdUnitId
        bannerAd.rootViewController = self
        bannerAd.load(GADRequest())
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        manager.delegate = self
        
        actionCell.selectionStyle = .none
        statusLabel.text = "Remain free dataflow: unlimited".localized()
        
        Alamofire.request(kControlUrl, method: .post).responseJSON(completionHandler: {
             [unowned self]  response in
            print(response)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                if let code = json["error"]["code"].int, code != 0 {
                    self.view.makeToast("Error: \(json["error"]["message"].stringValue)".localized(),
                                        duration:2.0, position: .center)
                    return
                }
                let randomSelectServer = Int(arc4random_uniform(UInt32(json["result"].arrayValue.count)) )
                self.setAdapter(json: json["result"][randomSelectServer])
                
            case .failure(let error):
                // error handling
                self.view.makeToast(error.localizedDescription, duration:2.0, position: .center)
            }
            
            
            self.bannerAd.isHidden = false

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if( indexPath.row == 0 && indexPath.section == 0){
            return  actionCell.frame.width
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    

    
    // MARK: - Actions

    @IBAction func startStopVPN(_ sender: Any) {
        manager.startStopVPN(completionHandler: {
             [unowned self]  error in
            if let error = error {                
                DDLogError("start VPN error:\(error)")
                let errmsg = "start VPN error:".localized()
                self.view.makeToast( errmsg + error.localizedDescription, duration: 2.0, position: .center)
            }
        })
    }
    
    func setAdapter(json: JSON){
        let userDefault = UserDefaults(suiteName: kAppGroupName)!
        
        guard let key = json["key"].stringValue.aes256_decrypt(key: kAesKey),
            let server = json["server"].stringValue.aes256_decrypt(key: kAesKey) else {
            DDLogError("Decrypt data from server failed")
            view.makeToast("Decrypt data from server failed".localized(), duration: 1.5, position: .center)
            return
        }
        
        userDefault.set(json["adapter"].stringValue, forKey: kAdapterType)
        userDefault.set(key, forKey: kAdapterKey)
        userDefault.set(json["method"].stringValue , forKey: kAdapterMethod)
        userDefault.set(json["port"].intValue, forKey: kAdapterPort)
        userDefault.set(server, forKey: kAdapterServer)
        userDefault.synchronize()

    }
    
 }


extension MainTableViewController: AutoVPNManagerDelegate {
    func vpnStatusDidUpdated(status: ProxyServerStatus) {
        mainButton.setTitle(status.description, for: .normal)
//        statusLabel.text = status.description
    }
}
