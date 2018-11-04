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

    public func fetchRepositories(count: Int) -> Maybe<[Repository]> {
        let query = RepositoriesQuery(first: count)

        return ApiClient.shared.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { return self.parse($0) }
            .observeOn(MainScheduler.instance)
    }

    private func parse(_ data: RepositoriesQuery.Data) -> [Repository] {
        var repositories: [Repository] = []
        if let repos = data.viewer.repositories.edges {
            for repo in repos {
                if let rep = repo?.node {
                    repositories.append(Repository(rep))
                }
            }
        }

        return repositories
    }

}
