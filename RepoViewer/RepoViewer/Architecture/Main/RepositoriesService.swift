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

    typealias RepoQueryResult = (repos: [Repository], cursor: String?)

    public func fetchRepositories(count: Int, cursor: String?) -> Maybe<RepoQueryResult> {
        let query = RepositoriesQuery(first: count, after: cursor)

        return ApiClient.shared.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { return self.parse($0) }
            .observeOn(MainScheduler.instance)
    }

    private func parse(_ data: RepositoriesQuery.Data) -> RepoQueryResult {
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

}
