//
//  IAPProducts.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/3/21.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation

public struct IAPProducts {
    
    public static let ikIAPmonth1 = kIAPmonth1
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [IAPProducts.ikIAPmonth1]
    
    public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
