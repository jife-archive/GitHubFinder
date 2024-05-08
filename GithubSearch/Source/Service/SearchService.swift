//
//  SearchService.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class SearchService {
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<GithubSearchTarget>()
    
    func fetchUserList(userName: String) -> Single<UserListDTO> {
        return Single.create { single in
            let disposable = self.provider.rx
                .request(.search(userName: userName))
                .filterSuccessfulStatusCodes()
                .map (UserListDTO.self)
                .subscribe(onSuccess: { res in
                    single(.success(res))
                })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}
