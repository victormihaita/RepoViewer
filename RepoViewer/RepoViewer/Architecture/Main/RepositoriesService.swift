//
//  RepositoriesService.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import RxSwift

class RepositoriesService {

    typealias RepoQueryResult = (repos:[[Repository]], languages: [String], cursor: String?)

    public func fetchRepositories(count: Int, cursor: String?) -> Maybe<RepoQueryResult> {
        let query = RepositoriesQuery(first: count, after: cursor)

        return ApiClient.shared.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { return self.parse($0) }
            .map { return self.sortRepos(repos: $0.repos, cursor: $0.cursor) }
            .observeOn(MainScheduler.instance)
    }

    private func parse(_ data: RepositoriesQuery.Data) -> (repos: [Repository], cursor: String?) {
        var repositories: [Repository] = []
        if let repos = data.viewer.repositories.edges {
            for repo in repos {
                if let rep = repo?.node {
                    repositories.append(Repository(rep))
                }
            }
        }

        return (repos: repositories, cursor: data.viewer.repositories.edges?.last??.cursor)
    }

    public func sortRepos(repos: [Repository], cursor: String?) -> RepoQueryResult {
        var repoDict: [[Repository]] = []
        var languages: [String] = []
        repos.forEach { repo in
            if let langs = repo.languages {
                langs.forEach { language in
                    if let index = languages.firstIndex(of: language.name) {
                        repoDict[index].append(repo)
                        repoDict[index].sort(by: { $0.stars > $1.stars })
                    } else {
                        languages.append(language.name)
                        languages.sort(by: { $0 < $1 })
                        repoDict.insert([repo], at: languages.firstIndex(of: language.name)!)
                    }
                }
            }

        }

        return (repos: repoDict, languages: languages, cursor: cursor)
    }

}
