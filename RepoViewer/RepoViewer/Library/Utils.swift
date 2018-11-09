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
        rightButtonTitle: String?,
        leftButtonAction: @escaping () -> Void,
        rightButtonAction: @escaping () -> Void?) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let leftButtonAction = UIAlertAction(title: leftButtonTitle, style: .cancel) { _ in
            leftButtonAction()
        }
        alert.addAction(leftButtonAction)

        if let rightText = rightButtonTitle {
            let rightButtonAction = UIAlertAction(title: rightText, style: .default) { _ in
                rightButtonAction()
            }
            alert.addAction(rightButtonAction)

        }

        parentVC.present(alert, animated: true, completion: nil)
    }

    static func getCredentials(in group: String, for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Credentials", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
                let authCredentials = dict[group] as? [String: String] else { return nil }

        return authCredentials[key]
    }


}
