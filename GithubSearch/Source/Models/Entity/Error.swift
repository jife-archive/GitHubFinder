//
//  Error.swift
//  GithubSearch
//
//  Created by 최지철 on 5/9/24.
//

import Foundation

enum APIError: Error {  // 에러를 처리하기 위한 객체
    case connectionError
    case invalidData
    case serverError
    case unauthorized
    case invaildURL
    case customError(String)
}
