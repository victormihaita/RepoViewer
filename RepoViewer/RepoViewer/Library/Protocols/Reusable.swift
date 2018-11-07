//
//  Reusable.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

    func dequeueCell<T: UITableViewCell>() -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }

}

