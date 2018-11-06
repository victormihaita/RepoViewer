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

    private var repoService: RepositoriesService?
    private var disposableRepos: Disposable?
    private let reposToFetch = 10
    private var cursor: String?

    private var repositories = PublishSubject<(repos:[[Repository]], languages: [String])>()
    private var fetchedRepos: [Repository] = []

    init() {
        repoService = RepositoriesService()
        fetchRepositories()
    }

    public func getRepositories() -> PublishSubject<(repos:[[Repository]], languages: [String])> {
        return repositories
    }

    private func fetchRepositories() {
        disposableRepos?.dispose()

        disposableRepos = repoService?.fetchRepositories(count: reposToFetch, cursor: cursor)
            .subscribe(
                onSuccess: { repos, languages, newCursor in
                    self.repositories.onNext((repos: repos, languages: languages))
                    self.cursor = newCursor
                    newCursor != nil ? self.fetchRepositories() : self.repositories.onCompleted()
                },
                onError: { self.repositories.onError($0) })
    }

}
