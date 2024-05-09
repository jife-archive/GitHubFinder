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
    
    // MARK: - Init

    init(coordinator: LoginCoordinator?, service: LoginService, urlConstants: UrlConstants) {
        self.coordinator = coordinator
        self.service = service
        self.urlConstants = urlConstants
    }
    // MARK: - In & Output

    struct Input {
        let loginTap: Signal<Void> // 로그인 버튼 클릭 시
    }
    
    struct Output {
        let url: Observable<URL?> // 깃허브 로그인 URL을 보여주는 변수
    }
    
    // MARK: - Method

    func transform(input: Input) -> Output {
        input.loginTap
            .emit(onNext: {  [weak self]  _ in
                let gitHubUrl = URL(string: "\(self?.urlConstants.GitHubURL ?? "")\(self?.urlConstants.ClientId ?? "")")
                self?.loginUrl.onNext(gitHubUrl)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification) /// 깃헙 로그인 후, 받은 code를 바탕으로 OAuth를 요청하는 로직입니다.
            .observe(on: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Single<AccessTokenDTO> in
                guard let self = self else { return .error(RxError.noElements) }
                return self.service.fetchAccessToken(clientID: self.urlConstants.ClientId, clientSecret: self.urlConstants.ClientSId, code: TokenManager.shared.getCodeKey() ?? "")
            }
            .subscribe(onNext: { accessToken in
                TokenManager.shared.saveToken(accessToken.access_token)
                self.coordinator?.pushMain()
            }, onError: { error in
                print("Error fetching access token: \(error)")
            })
            .disposed(by: disposeBag)

        return Output(url: loginUrl)
    }
}
