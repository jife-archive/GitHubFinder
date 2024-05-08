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
    private let searchResults = PublishSubject<[UserInfo]>()
    private let textInput = BehaviorSubject<String>(value: "")
    
    // MARK: - Init

    init(service: SearchService, coordinator: SearchCoordinator?) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: - In & Output

    struct Input {
        let viewWillAppear: Signal<Void>  // 뷰 생명주기 ViewWillAppear
        let inputText: Observable<String>  // 검색바의 텍스트 입력 시,
        let searchTapped: Signal<Void>   //  검색 버튼 클릭 시,
        let didSelectRowAt: Signal<String>  // 유저 리스트 클릭시,
        let clearTapped: Signal<Void>  // Clear버튼 클릭 시,
    }
    
    struct Output {
        let url: Observable<URL?> // 유저 클릭 시, 해당 유저의 깃허브 URL을 보여주는 변수
        let clearBtnVisible: Observable<Bool> // Clear 버튼 가시성 제어하는 변수
        let searchImgVisible: Observable<Bool> // 검색 돋보기 이미지 가시성 제어하는 변수
        let searchText: Observable<String>  // 검색 텍스트 바인딩용 Observable
        let searchResult: Observable<[UserInfo]>  // 검색 결과를 보여주는 변수
    }
    // MARK: - Method

    func transform(input: Input) -> Output {
        input.didSelectRowAt
            .emit(onNext: {  [weak self] res in
//                let url = URL(string: res)
//                self?.userInfoUrl.onNext(url)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .emit(onNext: {  [weak self]  _ in
                
            })
            .disposed(by: disposeBag)
        
        input.inputText
            .subscribe(onNext: {  [weak self]  text in
                self?.textInput.onNext(text)
            })
            .disposed(by: disposeBag)
        
        input.clearTapped
            .emit(onNext: {  [weak self] _ in
                self?.textInput.onNext("")
            })
            .disposed(by: disposeBag)
        
        let searchTrigger = input.searchTapped
            .asObservable()
            .withLatestFrom(input.inputText)
        
        searchTrigger // 검색 버튼의 입력을 감지하고 API 요청하는 로직
            .flatMapLatest { [weak self] text -> Observable<UserListDTO> in
                guard let self = self else { return Observable.empty() }
                return self.service.fetchUserList(userName: text)
                    .asObservable()
            }
            .subscribe(onNext: {  [weak self] userListDTO in
                self?.searchResults.onNext(userListDTO.items)
            })
            .disposed(by: disposeBag)
        
        let clearBtnVisible = textInput
            .map { $0.isEmpty }
            .distinctUntilChanged()
        
        let searchImgVisible = clearBtnVisible
            .map { !$0 }  // clearBtnVisible의 반대 값
        
        return Output(url: userInfoUrl,
                      clearBtnVisible: clearBtnVisible,
                      searchImgVisible: searchImgVisible, 
                      searchText: textInput.asObservable(), 
                      searchResult: searchResults
        )
    }
}
