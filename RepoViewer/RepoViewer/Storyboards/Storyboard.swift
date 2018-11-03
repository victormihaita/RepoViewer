//
//  Storyboard.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit

enum Storyboard: String {

    case main = "Main"
    case auth = "Auth"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {

        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        // swiftlint:disable:next force_cast
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }

}

extension UIViewController {

    class var storyboardID: String {
        return "\(self)"
    }

    static func instantiate (from appStoryboard: Storyboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }

}

