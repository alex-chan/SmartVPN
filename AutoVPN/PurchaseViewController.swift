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

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency

        return formatter
    }()

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

        IAPProducts.store.requestProducts {
            success, products in
            if success {
                self.products = products!
                self.tableView.reloadData()
            }
        }
    }

    func restoreTapped(_ sender: AnyObject) {
        IAPProducts.store.restorePurchases()
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

//        let l = UILabel()
//        l.text = IAPProducts.store.isProductPurchased(product.productIdentifier) ? "Purchased" : "Unpurchased"
//        l.sizeToFit()
//        purchaseCell.accessoryView = l
        purchaseCell.accessoryType = IAPProducts.store.isProductPurchased(product.productIdentifier) ? .checkmark : .none

        return purchaseCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        IAPProducts.store.buyProduct(products[indexPath.row])
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
