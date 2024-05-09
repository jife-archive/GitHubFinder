//
//  EndPoint.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

import Moya

enum GithubSearchTarget {
    case requestAccessToken(clientID: String, clientSecret: String, code: String) // 깃허브 로그인으로 토큰 요청
    case search(userName: String?) // 유저 검색
}
extension GithubSearchTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .requestAccessToken:
            return URL(string: "https://github.com/")!
        case .search:
            return URL(string: "https://api.github.com/")!

        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "search/users"
        case .requestAccessToken:
            return "login/oauth/access_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestAccessToken:
            return .post
    
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .search(let userName):
            var parameters: [String: Any] = [:]
            if let userName = userName {
                parameters["q"] = userName
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case .requestAccessToken(let clientID, let clientSecret, let code):
            let parameters: [String: Any] = [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": code
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .requestAccessToken:
            return ["Accept": "application/json"]
        case .search:
            return ["Accept": "application/json",
                    "Authorization": "token \(TokenManager.shared.getToken() ?? "")",
                    "X-GitHub-Api-Version" : "2022-11-28"
            ]
        }
    }
}
