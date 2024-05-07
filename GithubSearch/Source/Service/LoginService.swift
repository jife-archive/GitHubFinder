//
//  LoginService.swift
//  GithubSearch
//
//  Created by 최지철 on 5/7/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class LoginService {
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<GithubSearchTarget>()
    
    func fetchAccessToken(clientID: String, clientSecret: String, code: String) -> Single<AccessTokenDTO> {
        return Single.create { single in
            let disposable = self.provider.rx
                .request(.requestAccessToken(clientID: clientID, clientSecret: clientSecret, code: code))
                .filterSuccessfulStatusCodes()
                .map { response -> AccessTokenDTO in
                    let decoder = JSONDecoder()
                    return try decoder.decode(AccessTokenDTO.self, from: response.data)
                }
                .subscribe(onSuccess: { res in
                    single(.success(res))
                })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

}
