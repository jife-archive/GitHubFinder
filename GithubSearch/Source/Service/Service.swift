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

class Service {
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
                    print(res)
                    single(.success(res))
                })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func fetchUserList(userName: String) -> Single<UserListDTO> {
        return Single.create { single in
            let disposable = self.provider.rx
                .request(.search(userName: userName))
                .filterSuccessfulStatusCodes()
                .map(UserListDTO.self)
                .subscribe(onSuccess: { res in
                    print(res)
                    single(.success(res))
                }, onFailure: { error in
                    print(error)
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
extension Service { /// 에러코드를 처리하기 위한 Extension입니다.
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
