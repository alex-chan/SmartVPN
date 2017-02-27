//
//  PurchaseViewController
//  AutoVPN
//
//  Created by Alex Chan on 2017/2/25.
//  Copyright © 2017年 sunset. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
import SnapKit

private let kPURCHASE_CELL = "kPURCHASE_CELL"


class PurchaseViewController: UITableViewController {

    let dataSources = [
        [
            "title": "One-time purchase",
            "values" : ["10G(Month) $3.99/Once", "60G(Half-Year) $18.99/Once"]
        ],
        [
             "title":"Mini Subscription",
             "values": ["3G $0.99/Month", "20G $5.49/Half-Year"]
        ],[
            "title":"Classic Subscription",
            "values": ["10G $2.99/Month", "60G $16.99/Half-Year"]
        ]
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        let values = dataSources[section]["values"] as! [String]
        return values.count
    }
    

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 66.0
//    }
//    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let purchaseCell = tableView.dequeueReusableCell(withIdentifier: kPURCHASE_CELL) as! PurchaseCell
        
        let section = dataSources[indexPath.section]

        let values = section["values"] as! [String]
        let value = values[indexPath.row]
        
        let titles =  value.components(separatedBy:" ")
        purchaseCell.title.text = titles[0] as? String
        purchaseCell.subtitle.text = titles[1] as? String
        
//        guard values.count <= 3 else {
//            DDLogError("section values should less than 3")
//            exit(0)
//        }
//        
//        let buttonWidth = purchaseCell.contentView.frame.size.width / 3 - 20
//        let buttonHeight = purchaseCell.contentView.frame.size.height / 4 * 3
//        
//        for var i in 0..<values.count{
//            let button = UIButton()
//            button.setTitle(values[i], for: .normal)
//            button.layer.borderWidth = 1
//            button.layer.cornerRadius = 5
//            button.layer.borderColor = UIColor.gray.cgColor
//
//
//            button.addTarget(self, action: #selector(purchase), for: .touchUpInside)
//            button.setTitleColor(UIColor.blue, for: .normal)
//            
//            purchaseCell.contentView.addSubview(button)
//            
//            button.snp.makeConstraints {
//                make in
//                make.size.equalTo(CGSize(width: buttonWidth, height: buttonHeight))
//                make.centerY.equalTo(purchaseCell.contentView)
//                make.centerX.equalTo(purchaseCell.contentView.center.x / 2 * CGFloat(i+1) )
//                
//            }
//        }
        return purchaseCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section < dataSources.count else {
            return
        }
        DDLogInfo("Do purchase now")
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         let section = dataSources[section]["title"] as! String
        return section
    }
    
//    func purchase(button: UIButton){
//        DDLogInfo("purchase")
//    }

}
