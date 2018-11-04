//
//  MainViewController.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 150
            tableView.register(RepoTableCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
