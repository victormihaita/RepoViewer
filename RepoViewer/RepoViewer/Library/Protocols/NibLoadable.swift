//
//  NibLoadable.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
    static var nibName: String { get }
}

extension NibLoadable {

    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: Self.self))
    }

}

extension NibLoadable where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }

}

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) where T: Reusable, T: NibLoadable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

}
