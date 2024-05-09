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
                .map(UserListDTO.self)
                .subscribe(onSuccess: { res in
                    single(.success(res))
                }, onFailure: { error in
                    if let moyaError = error as? MoyaError {
                        single(.failure(self.handleError(moyaError)))
                    } else {
                        single(.failure(APIError.connectionError))
                    }
                })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

}
extension SearchService {
    private func handleError(_ moyaError: MoyaError) -> APIError {
        switch moyaError {
        case .statusCode(let response):
            switch response.statusCode {
            case 401:
                return .unauthorized
            case 404:
                return .invaildURL
            case 500...599:
                return .serverError
            default:
                return .customError("Unexpected status code: \(response.statusCode)")
            }
        case .imageMapping, .jsonMapping, .stringMapping:
            return .invalidData
        case .underlying(let error, _):
            return .customError("Unknown error: \(error.localizedDescription)")
        default:
            return .connectionError
        }
    }
}
