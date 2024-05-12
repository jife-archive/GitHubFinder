//
//  SearchViewModel.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    // MARK: - Properties
    
    private let service: Service
    weak var coordinator: SearchCoordinator?
    var disposeBag = DisposeBag()
    private let urlConstants = UrlConstants()
    private let userInfoUrl = PublishSubject<URL?>()
    private let searchResults = PublishSubject<[UserInfo]>()
    private let textInput = BehaviorSubject<String>(value: "")
    private let totalUserCount = PublishSubject<Int>()
    private let indicatorVisible = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Init

    init(service: Service, coordinator: SearchCoordinator?) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: - In & Output

    struct Input {
        let inputText: Observable<String>  // 검색바의 텍스트 입력 시,
        let searchTapped: Signal<Void>   //  검색 버튼 클릭 시,
        let didSelectRowAt: Signal<UserInfo>  // 유저 리스트 클릭시,
        let clearTapped: Signal<Void>  // Clear버튼 클릭 시,
    }
    
    struct Output {
        let url: Observable<URL?> // 유저 클릭 시, 해당 유저의 깃허브 URL을 보여주는 변수
        let clearBtnVisible: Observable<Bool> // Clear 버튼 가시성 제어하는 변수
        let searchImgVisible: Observable<Bool> // 검색 돋보기 이미지 가시성 제어하는 변수
        let searchText: Observable<String>  // 검색 텍스트 바인딩용 Observable
        let searchResult: Observable<[UserInfo]>  // 검색 결과를 보여주는 변수
        let totalSearchCount: Observable<Int>  // 검색된 총 유저의 수를 보여주는 변수
        let indicatorVisible: Driver<Bool>  // 인디게이터의 상태를 제어하는 변수
    }
    
    // MARK: - Method

    func transform(input: Input) -> Output {
        input.didSelectRowAt
            .emit(onNext: {  [weak self] res in
                self?.coordinator?.pushUserDetail(userUrl: res.url, userName: res.name)
            })
            .disposed(by: disposeBag)
        
        input.inputText     /// 서치바의 텍스트를 실시간으로 감지하는 로직입니다.
            .subscribe(onNext: {  [weak self]  text in
                self?.textInput.onNext(text)
            })
            .disposed(by: disposeBag)
        
        input.clearTapped   /// 유저가 clear버튼을 탭 했을때, 텍스트 삭제 및 키보드 내리는 로직입니다.
            .emit(onNext: {  [weak self] _ in
                self?.textInput.onNext("")
            })
            .disposed(by: disposeBag)
                
        let searchTrigger = input.searchTapped
            .asObservable()
            .withLatestFrom(input.inputText)
                
        searchTrigger /// 검색 버튼의 입력을 감지하고 API 요청하는 로직입니다.
            .flatMapLatest { [weak self] text -> Observable<UserListDTO> in
                guard let self = self else { return Observable.empty() }
                return self.service.fetchUserList(userName: text)
                    .asObservable()
                    .do(onSubscribe: { self.indicatorVisible.accept(true) }) // 검색 시작 시, 인디게이터 상태 제어
                    .catch { error -> Observable<UserListDTO> in    ///참고자료[2]를 참고하여 작성한 로직입니다.
                        if let apiError = error as? APIError {
                            switch apiError {
                            case .unauthorized:
                                // 에러 처리와 함께 로그인 재요청 로직을 실행하지만, 스트림을 종료시키지 않고 계속 진행.
                                self.coordinator?.pushRequestToken()
                                self.indicatorVisible.accept(false)
                                self.retryWithTokenRefresh()
                                return Observable.just(UserListDTO(totalCount: 1, incompleteResults: false, items: [])) // 기본 값 반환
                            default:
                                print("Other Error: \(apiError)")
                                return Observable.just(UserListDTO(totalCount: 1, incompleteResults: false, items: []))
                            }
                        } else {
                            print("Unhandled Error: \(error.localizedDescription)")
                            return Observable.just(UserListDTO(totalCount: 1, incompleteResults: false, items: []))
                        }
                    }
            }
            .subscribe(onNext: {  [weak self] userListDTO in  //검색 완료 시,
                
                self?.searchResults.onNext(userListDTO.items)
                self?.totalUserCount.onNext(userListDTO.totalCount)
                self?.indicatorVisible.accept(false)
                
            })
            .disposed(by: disposeBag)
        
        let clearBtnVisible = textInput /// claer버튼과 검색버튼 숨김 처리 로직입니다.
            .map { $0.isEmpty }
            .distinctUntilChanged()
        
        let searchImgVisible = clearBtnVisible
            .map { !$0 }  // clearBtnVisible의 반대 값
        
        return Output(url: userInfoUrl,
                      clearBtnVisible: clearBtnVisible,
                      searchImgVisible: searchImgVisible, 
                      searchText: textInput.asObservable(), 
                      searchResult: searchResults, 
                      totalSearchCount: totalUserCount, 
                      indicatorVisible: indicatorVisible.asDriver()
        )
    }
    
    private func retryWithTokenRefresh() {      /// 토큰을 재 요청하는 함수입니다. 참고자료[1]을 참고하여 작성하였습니다.
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .observe(on: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Single<AccessTokenDTO> in
                guard let self = self else { return .error(RxError.noElements) }
                return self.service.fetchAccessToken(clientID: self.urlConstants.ClientId, clientSecret: self.urlConstants.ClientSId, code: TokenManager.shared.getCodeKey() ?? "")
            }
            .subscribe(onNext: { accessToken in
                TokenManager.shared.saveToken(accessToken.access_token)
            }, onError: { error in
                print("Error fetching access token: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
