//
//  ApiClient.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Apollo
import ApolloAlamofire
import RxSwift

class ApiClient {

    static let shared = ApiClient()
    private var apollo: ApolloClient!
    private let apolloURL = URL(string: Utils.getCredentials(in: "GraphQL", for: "apiURL")!)

    init() {
        setApollo()
    }

    private func setApollo() {
        var headers: [String: String] = [:]
        if let token = KeychainService.loadApiToken(service: "ApiService", account: "userToken") {
            headers["Authorization"] = "Bearer \(token)"
        }

        let transport = AlamofireTransport(url: apolloURL!, headers: headers)
        let apolloStore = ApolloStore(cache: InMemoryNormalizedCache())
        apollo = ApolloClient(networkTransport: transport, store: apolloStore)
        apollo.cacheKeyForObject = { $0["id"] }
    }

    public func fetch<T: GraphQLQuery>(_ query: T, cachePolicy: CachePolicy) -> Maybe<T.Data> {
        return apollo.rx.fetch(query: query, cachePolicy: cachePolicy)
            .catchError { error in
                guard error.isAuthenticationError else {
                    return Maybe.error(error)
                }
                KeychainService.removeApiToken(service: "ApiService", account: "userToken")
                AppDelegate.shared.handleAppState()
                return Maybe.error(error)
        }
    }
}

extension Error {
    var isAuthenticationError: Bool {
        return (self as NSError).description.contains("401")
    }
}
