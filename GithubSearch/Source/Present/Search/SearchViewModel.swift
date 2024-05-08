//
//  SearchViewModel.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    // MARK: - Properties
    
    private let service: SearchService
    weak var coordinator: SearchCoordinator?
    var disposeBag = DisposeBag()
    private let userInfoUrl = PublishSubject<URL?>()

    // MARK: - Init

    init(service: SearchService, coordinator: SearchCoordinator?) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: - In & Output

    struct Input {
        let viewDidLoad: Signal<Void>
        let didSelectRowAt: Signal<String>
    }
    
    struct Output {
        let url: Observable<URL?>

    }
    // MARK: - Method

    func transform(input: Input) -> Output {
        input.didSelectRowAt
            .emit(onNext: { [weak self] res in
                let url = URL(string: res)
                self?.userInfoUrl.onNext(url)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .emit(onNext: {  [weak self]  _ in
                
            })
            .disposed(by: disposeBag)
        
        return Output(url: userInfoUrl)
    }
}
