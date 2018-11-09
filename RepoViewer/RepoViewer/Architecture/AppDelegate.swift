//
//  AppDelegate.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 02/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import OAuthSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate {
    func applicationHandle(url: URL) {
        if (url.host == "oauth-callback") {
            OAuth2Swift.handle(url: url)
        }
    }

    public func handleAppState() {
        KeychainService.loadApiToken(service: "ApiService", account: "userToken") != nil ? showMainApp() : showAuth()
    }

    private func showAuth() {
        let vc = AuthViewController.instantiate(from: .auth)
        let nav = UINavigationController(rootViewController: vc)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    private func showMainApp() {
        let vc = MainViewController.instantiate(from: .main)
        let nav = UINavigationController(rootViewController: vc)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.handleAppState()
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        applicationHandle(url: url)
        return true
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        applicationHandle(url: url)
        return true
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
