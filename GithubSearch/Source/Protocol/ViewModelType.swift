//
//  ViewModelType.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import Foundation

import RxSwift

// 뷰모델 기본 Protocol
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
