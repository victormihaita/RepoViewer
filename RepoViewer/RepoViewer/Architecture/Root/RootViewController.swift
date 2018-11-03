//
//  RootViewController.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handleAppState()
    }

    public func handleAppState() {
        UserDefaultsManager.getUserToken() != nil ? showMainApp() : showAuth()
    }

    private func showAuth() {
        removeActiveViews()
        let vc = AuthViewController.instantiate(from: .auth)
        addView(vc)
    }

    private func showMainApp() {
        removeActiveViews()
        let vc = MainViewController.instantiate(from: .main)
        addView(vc)
    }

    private func addView(_ vc: UIViewController) {
        DispatchQueue.main.async {
            self.addChild(vc)
            vc.view.frame = self.view.bounds
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }

    private func removeActiveViews() {
        DispatchQueue.main.async {
            for activeView in self.view.subviews {
                activeView.removeFromSuperview()
            }
        }
    }

}
