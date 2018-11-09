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
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var lockedView: UIImageView!
    private var starsView: UIImageView!
    private var starsLabel: UILabel!
    private var stackView: UIStackView!

    convenience init(owner: String, name: String) {
        self.init(nibName:nil, bundle:nil)
        repoName = name
        repoOwner = owner
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        initRepoDetailsSection()
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
        ownerLabel.textAlignment = .center
        ownerLabel.numberOfLines = 1
        view.addSubview(ownerLabel)
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            ownerLabel.centerXAnchor.constraint(equalTo: ownerImageView.centerXAnchor),
            ownerLabel.widthAnchor.constraint(equalTo: ownerImageView.widthAnchor, constant: 10),
            ownerLabel.topAnchor.constraint(equalTo: ownerImageView.bottomAnchor, constant: 8)
        ])
    }

    private func initRepoDetailsSection() {
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 24)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            titleLabel.leadingAnchor.constraint(equalTo: ownerImageView.trailingAnchor, constant: 14),
            titleLabel.topAnchor.constraint(equalTo: ownerImageView.topAnchor)
        ])

        descriptionLabel = UILabel()
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont(name: descriptionLabel.font.fontName, size: 17)
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            descriptionLabel.leadingAnchor.constraint(equalTo: ownerImageView.trailingAnchor, constant: 14),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            descriptionLabel.bottomAnchor.constraint(equalTo: ownerLabel.bottomAnchor)
        ])

        starsView = UIImageView()
        starsView.isHidden = false
        starsView.clipsToBounds = true
        view.addSubview(starsView)
        starsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            starsView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            starsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            starsView.heightAnchor.constraint(equalToConstant: 20),
            starsView.widthAnchor.constraint(equalToConstant: 20)
            ])

        starsLabel = UILabel()
        starsLabel.textColor = .black
        starsLabel.textAlignment = .right
        starsLabel.font = UIFont(name: descriptionLabel.font.fontName, size: 17)
        starsLabel.numberOfLines = 0
        view.addSubview(starsLabel)
        starsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            starsLabel.trailingAnchor.constraint(equalTo: starsView.leadingAnchor, constant: -2),
            starsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            starsLabel.heightAnchor.constraint(equalTo: starsView.heightAnchor)
        ])

        lockedView = UIImageView()
        lockedView.isHidden = false
        lockedView.clipsToBounds = true
        view.addSubview(lockedView)
        lockedView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lockedView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            lockedView.trailingAnchor.constraint(equalTo: starsLabel.leadingAnchor, constant: -14),
            lockedView.heightAnchor.constraint(equalToConstant: 20),
            lockedView.widthAnchor.constraint(equalToConstant: 20)
        ])

        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .trailing
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: starsView.bottomAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14)
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

        titleLabel.text = repository.name

        if let description = repository.description {
            descriptionLabel.text = description
        }

        if let languages = repository.languages {
            languages.forEach { language in
                let textLabel = UILabel()
                textLabel.backgroundColor = .gray
                textLabel.textColor = .white
                textLabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
                textLabel.text = language.name
                textLabel.textAlignment = .center

                stackView.addArrangedSubview(textLabel)
            }
        }

        starsView.image = repository.stars == 0 ?  #imageLiteral(resourceName: "icon_star_empty") : #imageLiteral(resourceName: "icon_star")
        starsLabel.text = "\(repository.stars ?? 0)"
        lockedView.image = repository.isPrivate ? #imageLiteral(resourceName: "icon_lock") : nil
    }

    func getDataFromUrl(url: URL, completion: @escaping ((_ data: Data) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(data)
            }
        }.resume()
    }

}
