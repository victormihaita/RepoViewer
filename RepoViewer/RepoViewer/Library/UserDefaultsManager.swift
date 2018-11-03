//
//  UserDefaultsManager.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation

class UserDefaultsManager {

    static func setUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: "loggedUserToken")
    }

    static func getUserToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: "loggedUserToken") {
            return token
        }
        return nil
    }

    static func removeUserToken() {
        UserDefaults.standard.removeObject(forKey: "loggedUserToken")
    }

}
