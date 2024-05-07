//
//  EndPoint.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

import Moya

enum GithubSearchTarget {
    case search(userName: String?) // 유저 검색
}
extension GithubSearchTarget: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
            
        case .search(userName: let userName):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            default:
                .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .search(let userName):
            var parameters: [String: Any] = [:]
            if let userName = userName {
                parameters["userName"] = userName
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
