//
//  ApiClient.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Apollo
import RxSwift

class ApiClient {

    static let shared = ApiClient()
    private var apollo: ApolloClient!
    private let apolloURL = URL(string: Utils.getCredentials(in: "GraphQL", for: "apiURL")!)

    init() {
        apollo = ApolloClient(url: apolloURL!)
        apollo.cacheKeyForObject = { $0["id"] }
    }

    public func fetch<T: GraphQLQuery>(_ query: T, cachePolicy: CachePolicy) -> Maybe<T.Data> {
        return apollo.rx.fetch(query: query, cachePolicy: cachePolicy)
    }

    public func perform<T: GraphQLMutation>(_ mutation: T) -> Maybe<T.Data> {
        return apollo.rx.perform(mutation: mutation)
    }

}