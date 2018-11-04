//
//  Repository.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation

struct Repository {

    let id: String!
    let name: String!
    let description: String?
    let isPrivate: Bool!
    let language: String?
    let stars: Int!

    init(_ data: RepositoriesQuery.Data.Viewer.Repository.Edge.Node) {
        id = data.id
        name = data.name
        description = data.description
        isPrivate = data.isPrivate
        language = data.languages?.nodes?.first??.name
        stars = data.stargazers.totalCount
    }

}
