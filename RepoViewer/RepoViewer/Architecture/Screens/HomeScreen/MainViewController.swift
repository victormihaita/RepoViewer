//
//  MainViewController.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 150
            tableView.register(RepoTableCell.self)
        }
    }

    private var viewModel = RepositoriesViewModel(Injection.getRepositoriesServiceDelegate())
    private let dataSource = RepositoriesTableDataSource()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        getRepositories()
    }

    private func getRepositories() {
        viewModel.getRepositories()
            .subscribe(
                onNext: {
                    self.dataSource.repositories.append(contentsOf: $0.repos)
                    self.dataSource.languages.append(contentsOf: $0.languages)
                },
                onError: { print($0) },
                onCompleted: { self.tableView.reloadData() })
            .disposed(by: disposeBag)
    }

}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepositoryDetailsViewController(
            owner: dataSource.repositories[indexPath.section][indexPath.row].username,
            name: dataSource.repositories[indexPath.section][indexPath.row].name
        )
        navigationController?.pushViewController(vc, animated: true)
    }

}
