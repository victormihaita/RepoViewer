//
//  TokenManager.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import Security

class TokenManager {

    // MARK: Retrieve the stored token from KeyChain
    static func loadApiToken(service: String, account: String) -> String? {
        var dataTypeRef: CFTypeRef?
        let status = SecItemCopyMatching(modifierQuery(service: service, account: account), &dataTypeRef)

        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
            return String(data: retrievedData, encoding: .utf8)
        } else {
            checkError(status)
            return nil
        }
    }

    // MARK: Save token to KeyChain
    static func saveApiToken(service: String, account: String, data: String) {
        guard let dataFromString = data.data(using: .utf8, allowLossyConversion: false) else {
            return
        }

        let keychainQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                              kSecAttrService: service,
                                              kSecAttrAccount: account,
                                              kSecValueData: dataFromString]

        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        checkError(status)
    }

    //MARK: Delete token from KeyChain
    static func removeApiToken(service: String, account: String) {
        let status = SecItemDelete(modifierQuery(service: service, account: account))
        checkError(status)
    }

    fileprivate static func modifierQuery(service: String, account: String) -> CFDictionary {
        let keychainQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                              kSecAttrService: service,
                                              kSecAttrAccount: account,
                                              kSecReturnData: kCFBooleanTrue]

        return keychainQuery as CFDictionary
    }

    fileprivate static func checkError(_ status: OSStatus) {
        if status != errSecSuccess {
            if #available(iOS 11.3, *),
                let err = SecCopyErrorMessageString(status, nil) {
                print("Operation failed: \(err)")
            } else {
                print("Operation failed: \(status)")
            }
        }
    }

}
