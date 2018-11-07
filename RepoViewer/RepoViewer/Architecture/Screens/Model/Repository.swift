//
//  Repository.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import UIKit

struct RepositoryShort {

    struct Language: Hashable {
        let name: String!
    }

    let name: String!
    let description: String?
    let isPrivate: Bool!
    let languages: [Language]?
    let username: String!
    let stars: Int!

    init(_ data: RepositoriesQuery.Data.Viewer.Repository.Edge.Node) {
        name = data.name
        description = data.description
        isPrivate = data.isPrivate
        languages = data.languages?.nodes?.map { Language(name: $0?.name) }
        stars = data.stargazers.totalCount
        username = data.owner.login
    }

}

struct Repository {

    struct Language: Hashable {
        let name: String!
    }

    struct Owner {
        let name: String!
        let avatarUrl: RepositoryQuery.URI!
    }

    let name: String!
    let description: String?
    let isPrivate: Bool!
    let languages: [Language]?
    let stars: Int!
    let owner: Owner!

    init(_ data: RepositoryQuery.Data.Repository?) {
        name = data?.name
        description = data?.description
        isPrivate = data?.isPrivate
        languages = data?.languages?.nodes?.map { Language(name: $0?.name) }
        stars = data?.stargazers.totalCount
        owner = Owner(name: data?.owner.login, avatarUrl: data?.owner.avatarUrl)
    }

}

public extension RepositoryQuery {
    public typealias URI = String
}


