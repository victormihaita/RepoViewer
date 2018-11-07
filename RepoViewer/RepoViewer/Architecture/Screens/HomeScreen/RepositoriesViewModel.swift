//
//  RepositoriesViewModel.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import RxSwift

class RepositoriesViewModel {

    weak var delegate: RepositoriesDelegate?

    private var disposableRepos: Disposable?
    private let reposToFetch = 20
    private var cursor: String?

    private var repositories = PublishSubject<(repos:[[RepositoryShort]], languages: [String])>()
    private var fetchedRepos: [RepositoryShort] = []

    init(_ factory: RepositoriesDelegate) {
        delegate = factory
        fetchRepositories()
    }

    public func getRepositories() -> PublishSubject<(repos:[[RepositoryShort]], languages: [String])> {
        return repositories
    }

    private func fetchRepositories() {
        disposableRepos?.dispose()

        disposableRepos = delegate?.fetchRepositories(count: reposToFetch, cursor: cursor)
            .subscribe(
                onSuccess: { repos, languages, newCursor in
                    self.repositories.onNext((repos: repos, languages: languages))
                    self.cursor = newCursor
                    newCursor != nil ? self.fetchRepositories() : self.repositories.onCompleted()
                },
                onError: { self.repositories.onError($0) })
    }

}
