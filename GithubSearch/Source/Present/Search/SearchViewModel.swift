//
//  SearchViewModel.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    init() {

    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }

    func transform(input: Input) -> Output {
        Output()
    }
}
