//
//  RepositoriesViewModel.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import RxSwift

class RepositoriesViewModel {

    private var repoService: RepositoriesService!
    private let reposToFetch = 100
    private let disposeBag = DisposeBag()

    typealias reposResult = (repos: [Repository.Language: [Repository]], languages: Set<Repository.Language>)
    private var repositories = PublishSubject<reposResult>()

    init() {
        repoService = RepositoriesService()
        fetchRepositories()
    }

    public func getRepositories() -> PublishSubject<reposResult> {
        return repositories
    }

    private func fetchRepositories() {
        repoService.fetchRepositories(count: reposToFetch)
            .subscribe(
                onSuccess: { repos in
                    var repoDict: [Repository.Language: [Repository]] = [:]
                    var languages: Set<Repository.Language> = []
                    repos.forEach { repo in
                        if let langs = repo.languages {
                            langs.forEach {
                                if var repositories = repoDict[$0] {
                                     repositories.append(repo)
                                } else {
                                    repoDict[$0] = [repo]
                                }

                                languages.insert($0)
                            }
                        }
                    }
                    self.repositories.onNext((repos: repoDict, languages: languages))
                },
                onError: { self.handle($0) })
            .disposed(by: disposeBag)
    }

    private func handle(_ error: Error) {
//        switch error {
//        case RxApolloError.graphQLErrors(let errors):
////            Analytics.shared.track(.error, properties: [
////                .errorMessage: errors.first?.errorDescription ?? error.localizedDescription,
////                .errorType: "API",
////                .errorScreen: "Gallery Details"
////            ])
//        default:
////            Analytics.shared.track(.error, properties: [
////                .errorMessage: error.localizedDescription,
////                .errorType: "API",
////                .errorScreen: "Gallery Details"
////                ])
//        }
    }

}
