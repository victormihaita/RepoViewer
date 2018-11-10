//
//  Injection.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 07/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation

class Injection {

    static func getRepositoryServiceDelegate() -> RepositoryDelegate {
        return RepositoriesService.create() as RepositoryDelegate
    }

    static func getRepositoriesServiceDelegate() -> RepositoriesDelegate {
        return RepositoriesService.create() as RepositoriesDelegate
    }

}
