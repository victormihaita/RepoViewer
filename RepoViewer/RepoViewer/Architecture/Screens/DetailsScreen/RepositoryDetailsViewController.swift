//
//  RepositoryDetailsViewController.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 06/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RepositoryDetailsViewController: UIViewController {

    private var repoName: String!
    private var repoOwner: String!
    private var disposeBag = DisposeBag()
    private var viewModel: RepositoryViewModel!

    private var ownerImageView: UIImageView!
    private var ownerLabel: UILabel!

    convenience init(owner: String, name: String) {
        self.init(nibName:nil, bundle:nil)
        repoName = name
        repoOwner = owner
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        viewModel = RepositoryViewModel(Injection.getRepositoryServiceDelegate(), owner: repoOwner, name: repoName)
        initSubviews()
        getRepo(with: repoName, repoOwner)
    }

    private func getRepo(with name: String, _ repoUsername: String) {
        viewModel.getRepository()
            .subscribe(
                onNext: { self.config(with: $0) },
                onError: { print($0) },
                onCompleted: {  })
            .disposed(by: disposeBag)
    }

    private func initSubviews() {
        initOwnerSection()
    }

    private func initOwnerSection() {
        ownerImageView = UIImageView()
        ownerImageView.isHidden = false
        ownerImageView.clipsToBounds = true
        ownerImageView.layer.cornerRadius = view.bounds.width * 0.15
        ownerImageView.layer.borderColor = UIColor.white.cgColor
        ownerImageView.layer.borderWidth = 1
        ownerImageView.backgroundColor = .white
        view.addSubview(ownerImageView)
        ownerImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            ownerImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            ownerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            ownerImageView.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.3),
            ownerImageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3)
        ])

        ownerLabel = UILabel()
        ownerLabel.textColor = .black
        view.addSubview(ownerLabel)
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            ownerLabel.centerXAnchor.constraint(equalTo: ownerImageView.centerXAnchor),
            ownerLabel.heightAnchor.constraint(equalToConstant: 20),
            ownerLabel.topAnchor.constraint(equalTo: ownerImageView.bottomAnchor, constant: 8)
        ])
    }

    private func config(with repository: Repository) {
        ownerLabel.text = repository.owner.name

        if let urlString = repository.owner.avatarUrl, let url = URL(string: urlString) {
            getDataFromUrl(url: url) { data in
                DispatchQueue.main.async {
                    self.ownerImageView.image = UIImage(data: data)
                }
            }
        }
    }

    func getDataFromUrl(url: URL, completion: @escaping ((_ data: Data) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(data)
            }
        }.resume()
    }

}
