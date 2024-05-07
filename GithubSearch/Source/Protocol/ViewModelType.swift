//
//  ViewModelType.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import Foundation

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
