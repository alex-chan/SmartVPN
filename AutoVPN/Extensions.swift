//
//  Extensions.swift
//  AutoVPN
//
//  Created by Alex Chan on 2017/3/10.
//  Copyright © 2017年 sunset. All rights reserved.
//

import Foundation
import CryptoSwift

extension String {
    func aes256_decrypt(key: String) -> String? {

        guard let data2 = Data(base64Encoded: self, options:.ignoreUnknownCharacters) else {
            return nil
        }

        let iv = Array(data2.bytes[0..<16])
        let keyArray = Array(key.utf8).sha256()
        do {
            let aes = try AES(key: keyArray, iv: iv, blockMode: .CTR)
            let c = Array(data2.bytes[16..<data2.count])
            let b = try aes.decrypt( c )

            let e = b.flatMap {  String(UnicodeScalar($0) ) }

            return e.joined()

        } catch {
            print(error)
            return nil
        }
    }
}
