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
    
    // MARK: - Init

    init(service: SearchService, coordinator: SearchCoordinator?) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: - In & Output

    struct Input {
        let viewWillAppear: Signal<Void>
        let didSelectRowAt: Signal<String>
    }
    
    struct Output {
        let url: Observable<URL?>

    }
    // MARK: - Method

    func transform(input: Input) -> Output {
        Output(url: <#Observable<URL?>#>)
    }
}
