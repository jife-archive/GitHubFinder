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
        let inputText: Observable<String>
        let searchTapped: Signal<Void>
        let didSelectRowAt: Signal<String>
    }
    
    struct Output {
        let url: Observable<URL?> // 유저 클릭 시, 해당 유저의 깃허브 URL을 보여주는 변수
        let clearBtnVisible: Observable<Bool> // Clear 버튼 가시성 제어하는 변수
        let searchImgVisible: Observable<Bool> // 검색 돋보기 이미지 가시성 제어하는 변수
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
        
        let clearBtnVisible = input.inputText
            .map { $0.isEmpty }
            .distinctUntilChanged()
        
        let searchImgVisible = clearBtnVisible
            .map { !$0 }  // clearBtnVisible의 반대 값

        
        return Output(url: userInfoUrl,
                      clearBtnVisible: clearBtnVisible,
                      searchImgVisible: searchImgVisible
        )
    }
}
