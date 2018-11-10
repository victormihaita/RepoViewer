//
//  RepositoriesService.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import RxSwift

typealias RepoQueryResult = (repos:[[RepositoryShort]], languages: [String], cursor: String?)

protocol RepositoriesDelegate: class {
    func fetchRepositories(count: Int?, cursor: String?) -> Maybe<RepoQueryResult>
    func searchRepositories(count: Int?, cursor: String?, type: SearchType!, query: String!) -> Maybe<RepoQueryResult>
}

protocol RepositoryDelegate: class {
    func fetchRepository(for owner: String, with name: String) -> Maybe<Repository>
}

class RepositoriesService: RepositoriesDelegate, RepositoryDelegate {

    private var client: ApiClient!

    static func create() -> RepositoriesService {
        return RepositoriesService(ApiClient.shared)
    }

    init(_ client: ApiClient) {
        self.client = client
    }

    // MARK: Fetch a single `Repository`
    // - param `owner` (the user whose repository is to be displayed)
    // - param `namez (the name of the repository)
    public func fetchRepository(for owner: String, with name: String) -> Maybe<Repository> {
        let query = RepositoryQuery(owner: owner, name: name)

        return client.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { return Repository($0.repository) }
            .observeOn(MainScheduler.instance)
    }

    // MARK: Fetch multiple `Repository`
    // - param `count` (number of repositories to fetch)
    // - param `cursor` (the initial position for fetching data) - for pagination

    public func fetchRepositories(count: Int?, cursor: String?) -> Maybe<RepoQueryResult> {
        let query = RepositoriesQuery(first: count, after: cursor)

        return ApiClient.shared.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { return self.parse($0) }
            .map { return self.sortRepos(repos: $0.repos, cursor: $0.cursor) }
            .observeOn(MainScheduler.instance)
    }

    // MARK: Fetch multiple `Repository` by a given query
    // - param `count` (number of repositories to fetch)
    // - param `cursor` (the initial position for fetching data) - for pagination
    // - param `type` - the type of data that can be fetched (Repos, users, issues)

    public func searchRepositories(count: Int?, cursor: String?, type: SearchType!, query: String!) -> Maybe<RepoQueryResult> {
        let query = SearchQuery(queryText: query, first: count, after: cursor, type: type)

        return client.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { return self.parse($0) }
            .map { return self.sortRepos(repos: $0.repos, cursor: $0.cursor) }
            .observeOn(MainScheduler.instance)
    }

    // MARK: Parse the `fetchRepositories()` results

    private func parse(_ data: RepositoriesQuery.Data) -> (repos: [RepositoryShort], cursor: String?) {
        var repositories: [RepositoryShort] = []
        if let repos = data.viewer.repositories.edges {
            for repo in repos {
                if let rep = repo?.node {
                    repositories.append(RepositoryShort(rep))
                }
            }
        }

        return (repos: repositories, cursor: data.viewer.repositories.edges?.last??.cursor)
    }

    // MARK: Parse the search query results
    
    private func parse(_ data: SearchQuery.Data) -> (repos: [RepositoryShort], cursor: String?) {
        var repositories: [RepositoryShort] = []
        if let repos = data.search.edges {
            for repo in repos {
                if let rep = repo?.node?.asRepository {
                    repositories.append(RepositoryShort(rep))
                }
            }
        }

        return (repos: repositories, cursor: data.search.edges?.last??.cursor)
    }

    // MARK: Sort the fetched repositories in sections (based on language) and sorted by number of stars

    private func sortRepos(repos: [RepositoryShort], cursor: String?) -> RepoQueryResult {
        var repoDict: [[RepositoryShort]] = []
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
