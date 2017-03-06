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


class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var actionCell: UITableViewCell!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    let manager = AutoVPNManager()
   
     


    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        DDLog.add(DDTTYLogger.sharedInstance()) // TTY = Xcode console
        manager.delegate = self
        
        actionCell.selectionStyle = .none
        
        statusLabel.text = "Free Currently".localized()

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
        
        manager.startStopVPN {
            error in
            if let error = error {
                
                DDLogError("start VPN error:\(error)")
            }

        }
        
    }
    
    

    
 }


extension MainTableViewController: AutoVPNManagerDelegate {
    func vpnStatusDidUpdated(status: ProxyServerStatus) {
        mainButton.setTitle(status.description, for: .normal)
//        statusLabel.text = status.description
    }
}
