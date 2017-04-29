//
//  ProxyModeViewController.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/2/24.
//  Copyright © 2017年 sunset. All rights reserved.
//

import UIKit
import Foundation

class ProxyModeViewController: UITableViewController {

    let defaults =  UserDefaults(suiteName: kAppGroupName)!
    let kPROXY_MODE = "proxy_mode"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
         

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mode = defaults.integer(forKey: kPROXY_MODE)
        let indexPath = IndexPath(row: mode, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        defaults.set(indexPath.row, forKey: kPROXY_MODE)

    }
    

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
    
        
        cell?.accessoryType = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        defaults.synchronize()
        
        super.viewWillDisappear(animated)
    }

}
