//
//  TokenManger.swift
//  GithubSearch
//
//  Created by 최지철 on 5/7/24.
//

import Foundation

final class TokenManager { /// 싱글톤 패턴으로 토큰을 관리하는 클래스입니다.
    static let shared = TokenManager()

    private let userDefaults = UserDefaults.standard
    private let tokenKey = "accessToken"
    private let codeKey = "code"
    
    private init() {}

    func saveCodeKey(_ code: String) {
        userDefaults.set(code, forKey: codeKey)
    }
    
    func getCodeKey() -> String? {
        return userDefaults.string(forKey: codeKey)
    }

    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        return userDefaults.string(forKey: tokenKey)
    }

    func clearToken() {
        userDefaults.removeObject(forKey: tokenKey)
    }
    
    func isTokenValid() -> Bool {
        return getToken() != nil
    }
}

