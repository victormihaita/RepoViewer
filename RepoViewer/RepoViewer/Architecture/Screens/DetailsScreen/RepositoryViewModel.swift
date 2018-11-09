//
//  RepositoryViewModel.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 07/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryViewModel {

    weak var delegate: RepositoryDelegate?
    
    private var disposeBag = DisposeBag()
    private let reposToFetch = 20
    private var cursor: String?
    private var repository = PublishSubject<Repository>()

    init(_ factory: RepositoryDelegate, owner: String, name: String) {
        delegate = factory
        fetchRepository(for: owner, name: name)
    }

    public func getRepository() -> PublishSubject<Repository> {
        return repository
    }

    public func fetchRepo(owner: String, name: String) {
        self.fetchRepository(for: owner, name: name)
    }

    private func fetchRepository(for owner: String, name: String) {

        delegate?.fetchRepository(for: owner, with: name)
            .subscribe(
                onSuccess: { self.repository.onNext($0) },
                onError: { self.repository.onError($0) },
                onCompleted: { self.repository.onCompleted() })
            .disposed(by: disposeBag)
    }

}
