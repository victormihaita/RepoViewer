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

    private var delegate: RepositoriesDelegate?

    private var repositories = PublishSubject<(repos:[[RepositoryShort]], languages: [String])>()
    private var disposableRepos: Disposable?
    private var disposableSearch: Disposable?
    private let reposToFetch = 50
    private var cursor: String?

    init(_ factory: RepositoriesDelegate) {
        self.delegate = factory
    }

    public func getRepositories() -> PublishSubject<(repos:[[RepositoryShort]], languages: [String])> {
        return repositories
    }

    public func fetchViewerRepos() {
        cursor = nil
        disposableSearch?.dispose()
        fetchRepositories()
    }

    public func searchRepos(with query: String) {
        cursor = nil
        disposableRepos?.dispose()
        searchRepositories(with: query)
    }

    private func fetchRepositories() {
        disposableRepos?.dispose()
        disposableRepos = delegate?.fetchRepositories(count: reposToFetch, cursor: cursor)
            .subscribe(
                onSuccess: { repos, languages, newCursor in
                    self.repositories.onNext((repos: repos, languages: languages))
                    self.cursor = newCursor
                },
                onError: { self.repositories.onError($0) })
    }

    private func searchRepositories(with query: String) {
        disposableSearch?.dispose()
        disposableSearch = delegate?.searchRepositories(count: reposToFetch, cursor: cursor, type: .repository, query: query)
            .subscribe(
                onSuccess: { repos, languages, newCursor in
                    self.repositories.onNext((repos: repos, languages: languages))
                    self.cursor = newCursor
                },
                onError: { self.repositories.onError($0) })
    }

}
