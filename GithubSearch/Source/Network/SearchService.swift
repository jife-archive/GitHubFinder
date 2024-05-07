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
}
