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

    private var repositories = PublishSubject<[Repository.Language: [Repository]]>()
    private var fetchedRepos: [Repository] = []

    init() {
        repoService = RepositoriesService()
        fetchRepositories()
    }

    public func getRepositories() -> PublishSubject<[Repository.Language: [Repository]]> {
        return repositories
    }

    private func fetchRepositories() {
        disposableRepos?.dispose()

        disposableRepos = repoService?.fetchRepositories(count: reposToFetch, cursor: cursor)
            .subscribe(
                onSuccess: { repos, newCursor in
                    self.fetchedRepos.append(contentsOf: repos)
                    self.repositories.onNext(self.sortedList(for: self.fetchedRepos))
                    self.cursor = newCursor
                    newCursor != nil ? self.fetchRepositories() : self.repositories.onCompleted()
                },
                onError: { self.repositories.onError($0) })
    }

    private func sortedList(for repos: [Repository]) -> [Repository.Language: [Repository]] {
        var repoDict: [Repository.Language: [Repository]] = [:]
        repos.forEach { repo in
            if let langs = repo.languages {
                langs.forEach {
                    if var repository = repoDict[$0] {
                        repository.append(repo)
                    } else {
                        repoDict[$0] = [repo]
                    }
                }
            }
        }

        return repoDict
    }

}
