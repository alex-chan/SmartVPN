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
import StoreKit

private let kPURCHASE_CELL = "kPURCHASE_CELL"


class PurchaseViewController: UITableViewController {

//    let dataSources = [
//        [
//            "title": "One-time purchase",
//            "values" : ["10G(Month) $3.99/Once", "60G(Half-Year) $18.99/Once"]
//        ],
//        [
//             "title":"Mini Subscription",
//             "values": ["3G $0.99/Month", "20G $5.49/Half-Year"]
//        ],[
//            "title":"Classic Subscription",
//            "values": ["10G $2.99/Month", "60G $16.99/Half-Year"]
//        ]
//        
//    ]
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var iap = IAPHelper(productIds: [kIAPmonth1])
    
    var products = [SKProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let restoreButton = UIBarButtonItem(title: "Restore",
                                            style: .plain,
                                            target: self,
                                            action: #selector(PurchaseViewController.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        iap.requestProducts {
            success, products in
            if success {
                self.products = products!
                self.tableView.reloadData()
            }
        }
    }
    
    func restoreTapped(_ sender: AnyObject) {
        iap.restorePurchases()
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
    
    
}
// MARK: - UITableViewDataSource

extension PurchaseViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return products.count
    }
    

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 66.0
//    }
//    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let purchaseCell = tableView.dequeueReusableCell(withIdentifier: kPURCHASE_CELL) as! PurchaseCell
        
        let product = products[indexPath.row]
        
        PurchaseViewController.priceFormatter.locale = product.priceLocale

        purchaseCell.title.text = products[0].localizedTitle
        purchaseCell.subtitle.text = PurchaseViewController.priceFormatter.string(from: product.price)
        
        let l = UILabel()
        l.text = iap.isProductPurchased(product.productIdentifier) ? "Purchased" : "Unpurchased"
        purchaseCell.accessoryView = l

        return purchaseCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        iap.buyProduct(products[indexPath.row])
        DDLogInfo("Do purchase now")
        
    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return products.count
//    }
    
//    func purchase(button: UIButton){
//        DDLogInfo("purchase")
//    }

}
