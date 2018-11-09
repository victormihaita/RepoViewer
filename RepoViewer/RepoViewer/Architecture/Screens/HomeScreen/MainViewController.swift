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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 150
            tableView.keyboardDismissMode = .onDrag
            tableView.register(RepoTableCell.self)
        }
    }

    private var viewModel: RepositoriesViewModel!
    private let dataSource = RepositoriesTableDataSource()
    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        let signOutButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = signOutButton

        viewModel = RepositoriesViewModel(Injection.getRepositoriesServiceDelegate())
        tableView.dataSource = dataSource

        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe( onNext: {
                $0 == "" ? self.viewModel.fetchViewerRepos() : self.viewModel.searchRepos(with: $0)
                self.dataSource.repositories = []
                self.dataSource.languages = []
                self.tableView.reloadData() })
            .disposed(by: disposeBag)

        viewModel.getRepositories()
            .subscribe(
                onNext: {
                    self.dataSource.repositories.append(contentsOf: $0.repos)
                    self.dataSource.languages.append(contentsOf: $0.languages)
                    self.tableView.reloadData()
                },
                onError: { self.handle($0) },
                onCompleted: { self.tableView.reloadData() })
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext:{
                let vc = RepositoryDetailsViewController(
                    owner: self.dataSource.repositories[$0.section][$0.row].username,
                    name: self.dataSource.repositories[$0.section][$0.row].name
                )
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    @objc func signOut() {
        KeychainService.removeApiToken(service: "ApiService", account: "userToken")
        AppDelegate.shared.handleAppState()
    }

    func handle(_ error: Error) {
        Utils.showPopUp(
            parentVC: self,
            title: "Error",
            message: error.localizedDescription,
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Retry",
            leftButtonAction: {},
            rightButtonAction: { self.viewModel.fetchViewerRepos() }
        )
    }

}
