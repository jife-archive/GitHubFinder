//
//  UserListDTO.swift
//  GithubSearch
//
//  Created by 최지철 on 5/8/24.
//

import Foundation

// 검색시, 상위 응답 객체
struct UserListDTO: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [UserInfo]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// 개별 사용자 정보 객체
struct UserInfo: Decodable {
    let name: String
    let url: String
    let imgURL: String
    
    enum CodingKeys: String, CodingKey {
        case imgURL = "avatar_url"
        case name = "login"
        case url = "html_url"
    }
}
