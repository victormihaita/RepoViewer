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

    public var repositories: [Repository.Language: [Repository]] = [:]
    public var languages: [Repository.Language] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = repositories[languages[section]] {
            return repos.count
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return languages[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoTableCell = tableView.dequeueCell(for: indexPath)
        if let repos = repositories[languages[indexPath.section]] {
            cell.config(with: repos[indexPath.row])
        }
        return cell
    }

}
