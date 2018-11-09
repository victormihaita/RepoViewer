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
        resetApollo()
    }

    private func resetApollo() {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer \(UserDefaultsManager.getUserToken() ?? "INVALID")"

        let transport = AlamofireTransport(url: apolloURL!, headers: headers)
        apollo = ApolloClient(networkTransport: transport)
        apollo.cacheKeyForObject = { $0["id"] }
    }

    public func fetch<T: GraphQLQuery>(_ query: T, cachePolicy: CachePolicy) -> Maybe<T.Data> {
        return apollo.rx.fetch(query: query, cachePolicy: cachePolicy)
            .catchError { error in
                guard error.isAuthenticationError else {
                    return Maybe.error(error)
                }
                UserDefaultsManager.removeUserToken()
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
