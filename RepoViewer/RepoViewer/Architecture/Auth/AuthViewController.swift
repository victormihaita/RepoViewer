//
//  AuthViewController.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 03/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit
import SafariServices
import OAuthSwift
import RxSwift
import RxCocoa

enum OAuthParameters {
    case consumerKey
    case consumerSecret
    case authorizeUrl
    case accessTokenUrl
    case responseType
}

class AuthViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!

    private var oAuthSwift: OAuth2Swift!
    private var params: [OAuthParameters: String] = [:]
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        params = [
            .consumerKey:     Utils.getCredentials(in: "Auth", for: "consumerKey")!,
            .consumerSecret:  Utils.getCredentials(in: "Auth", for: "consumerSecret")!,
            .authorizeUrl:    Utils.getCredentials(in: "Auth", for: "authorizeUrl")!,
            .accessTokenUrl:  Utils.getCredentials(in: "Auth", for: "accessTokenUrl")!,
            .responseType:    Utils.getCredentials(in: "Auth", for: "responseType")!
        ]

        signInButton.rx.tap
            .bind { self.gitHubAuth(with: self.params) }
            .disposed(by: disposeBag)
    }

    func gitHubAuth(with parameters: [OAuthParameters: String]){
        oAuthSwift = OAuth2Swift(
            consumerKey:    parameters[.consumerKey]!,
            consumerSecret: parameters[.consumerSecret]!,
            authorizeUrl:   parameters[.authorizeUrl]!,
            accessTokenUrl: params[.accessTokenUrl]!,
            responseType:   params[.responseType]!
        )

        oAuthSwift.authorizeURLHandler = getUrlHandler()
        let state = "GITHUB"

        oAuthSwift.authorize(
            withCallbackURL: URL(string: Utils.getCredentials(in: "Auth", for: "callbackURL")!),
            scope: "user,repo",
            state: state,
            success: { credential, response, parameters in
                UserDefaultsManager.setUserToken(token: credential.oauthToken)
                AppDelegate.shared.handleAppState()
            },
            failure: { error in
                Utils.showPopUp(
                    parentVC: self,
                    title: "Error \(error.errorCode)",
                    message: error.description,
                    leftButtonTitle: "Cancel",
                    rightButtonTitle: "Retry",
                    leftButtonAction: {},
                    rightButtonAction: { self.gitHubAuth(with: self.params) }
                )
            }
        )
    }

    func getUrlHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 9.0, *) {
            let handler = SafariURLHandler(viewController: self, oauthSwift: self.oAuthSwift)
            handler.factory = { return SFSafariViewController(url: $0) }
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }

}
