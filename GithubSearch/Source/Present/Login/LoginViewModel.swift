//
//  LoginViewModel.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    // MARK: - Properties

    var disposeBag = DisposeBag()
    weak var coordinator: LoginCoordinator?
    private let service: LoginService
    private let loginUrl = PublishSubject<URL?>()
    private let urlConstants: UrlConstants
    private let tokenManager = TokenManager()
    
    // MARK: - Init

    init(coordinator: LoginCoordinator?, service: LoginService, urlConstants: UrlConstants) {
        self.coordinator = coordinator
        self.service = service
        self.urlConstants = urlConstants
    }
    // MARK: - In & Output

    struct Input {
        let loginTap: Signal<Void>
    }
    
    struct Output {
        let url: Observable<URL?>
    }
    
    // MARK: - Method

    func transform(input: Input) -> Output {
        input.loginTap
            .emit(onNext: {  [weak self]  _ in
                let gitHubUrl = URL(string: "\(self?.urlConstants.GitHubURL ?? "")\(self?.urlConstants.ClientId ?? "")")
                self?.loginUrl.onNext(gitHubUrl)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter
             .default
             .rx
             .notification(UIApplication.willEnterForegroundNotification)
             .subscribe(on: MainScheduler.instance)
             .subscribe(onNext: { [weak self] _ in
                 guard let self = self else { return }
                 self.service.fetchAccessToken(clientID: urlConstants.ClientId, clientSecret: urlConstants.ClientSId, code: tokenManager.getCodeKey() ?? "")
                     .subscribe(onSuccess: { res in
                         self.tokenManager.saveToken(res.access_token)
                         self.coordinator?.pushMain()
                     }, onFailure: { error in
                         print("Error fetching access token: \(error)")
                     })
                     .disposed(by: self.disposeBag)
             })
             .disposed(by: self.disposeBag)

        
        return Output(url: loginUrl)
    }
}
