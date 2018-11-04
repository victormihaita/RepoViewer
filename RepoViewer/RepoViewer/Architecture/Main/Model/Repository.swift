//
//  Repository.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import UIKit

struct Repository {

    struct Language: Hashable {
        let name: String!
    }

    let id: String!
    let name: String!
    let description: String?
    let isPrivate: Bool!
    let languages: [Language]?
    let stars: Int!

    init(_ data: RepositoriesQuery.Data.Viewer.Repository.Edge.Node) {
        id = data.id
        name = data.name
        description = data.description
        isPrivate = data.isPrivate
        languages = data.languages?.nodes?.map { Language(name: $0?.name) }
        stars = data.stargazers.totalCount
    }

}
