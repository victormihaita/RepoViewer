//
//  Utils.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import UIKit

class Utils {

    static func showPopUp(
        parentVC: UIViewController,
        title: String,
        message: String,
        leftButtonTitle: String,
        rightButtonTitle: String,
        leftButtonAction: @escaping () -> Void,
        rightButtonAction: @escaping () -> Void?) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let leftButtonAction = UIAlertAction(title: leftButtonTitle, style: .cancel) { _ in
            leftButtonAction()
        }
        let rightButtonAction = UIAlertAction(title: rightButtonTitle, style: .default) { _ in
            rightButtonAction()
        }
        alert.addAction(leftButtonAction)
        alert.addAction(rightButtonAction)

        parentVC.present(alert, animated: true, completion: nil)
    }

    static func getCredentials(for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Auth", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
                let authCredentials = dict["AuthCredentials"] as? [String: String] else { return nil }

        return authCredentials[key]
    }


}
