//
//  Errors.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/3/12.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import Localize_Swift

enum SmartVPNError: Error {
    case invalidConfig
    var localizedDescription: String {
        switch self {
        case .invalidConfig:
            return "Invalid configuration from server".localized()
        }
    }
}
