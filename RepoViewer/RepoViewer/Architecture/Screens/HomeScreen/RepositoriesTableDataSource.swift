//
//  RepositoriesTableDataSource.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import UIKit

class RepositoriesTableDataSource: NSObject, UITableViewDataSource {

    public var repositories: [[Repository]] = []
    public var languages: [String] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return languages[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoTableCell = tableView.dequeueCell(for: indexPath)
        let repo = repositories[indexPath.section][indexPath.row]
        cell.config(with: repo)
        return cell
    }

}
