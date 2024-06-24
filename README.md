
# ⚙️ Framework / Architecture

---

> **UIKit**
> 

> **SPM**
> 
- **Then**
- **Moya**
- SnapKit
- RxSwift
- Kingfisher

> **MVVM - C**
> 
- Coordinator
- Singleton
- Input, Output



# **📲** UML

---
![213](https://github.com/jife-archive/GitHubFinder/assets/114370871/e2c4e69a-5554-4692-9dd2-40594c9babcf)
![스크린샷 2024-05-10 오후 5 36 41](https://github.com/jife-archive/GitHubFinder/assets/114370871/90713cb2-192c-4156-8b14-bbe9c487cbb8)


# **📃** 커스텀 Protocol 및 Extension 문서

---

## Protocol

---

- **ViewModelType**

```swift

// 뷰모델 기본 Protocol
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
```

- **Input, Output 패턴**을 사용하기 위한 **ViewModelType**프로토콜입니다.
- **transform** 함수는  View로부터 Input을 받아 변환하여 다시 View로 Output을 제공하는 역할을 합니다.
- 모든 ViewModel은 **`ViewModelType`**을 따라야 하는데 이 때 `Input`과 `Output` 타입 내의 프로퍼티는 var 대신 let을, Subject(또는 Relay) 대신 Observable만 사용하도록 한정합니다. 
 이를 통해 `ViewModel`에서 의도한 `Input`과 `Output`의 데이터 방향성을 `View`에서 오용하는 것을 방지할 수 있습니다.

- **Coordinator**

```swift
// 기본 Coordinator Protocol
protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: any Coordinator)
}
protocol Coordinator: AnyObject {
    
    var childCoordinators: [any Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    func start()
    func finish()
}
extension Coordinator { /// Coordinator의 네비게이션 스택을 효율적으로 관리하기 위한 Extension입니다.
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
    
    func dismiss(animated: Bool = false) {
        navigationController.presentedViewController?.dismiss(animated: animated)
    }
    
    func popupViewController(animated: Bool = false) {
        navigationController.popViewController(animated: animated)
    }
}
```

- **Coordinator Protocol과 Extension**은 따로 설명하기가, 모호하여 함께 작성 하였습니다.
- **Coordinator** **패턴**을 사용하기 위한 Coordinator 프로토콜입니다.
- Coordinator 프로토콜로   **`childCoordinators`** 배열을 통해 자신의 자식 코디네이터들을 관리합니다. 이는 네비게이션 스택에서 뷰 컨트롤러들이 활성화되거나 제거될 때 코디네이터간의 연결을 유지하기 위함입니다
- Coordinator의 완료 상태를 상위 코디네이터에게 알릴 수 있습니다. 이를 통해 코디네이터 간의 종속성을 관리하고, 특정 코디네이터의 생명주기가 끝났을 때 필요한 처리를 할 수 있습니다.
- Coordinator의 **Extension**
    1. **finish**: 코디네이터의 작업이 끝났을 때 호출됩니다. 이 메소드는 코디네이터의 모든 자식 코디네이터를 제거하고, 상위 코디네이터에게 작업 완료를 알립니다.
    2. **dismiss**: 현재 코디네이터가 관리하는 뷰 컨트롤러가 다른 뷰 컨트롤러를 모달 형태로 표시했을 때, 이를 해제합니다.
    3. **popupViewController**: 네비게이션 스택에서 현재 뷰 컨트롤러를 `Pop`합니다. 이는 사용자가 이전 화면으로 돌아갈 때 사용됩니다.

# Extension

---

- **UITextField 의 Extension**

```swift
extension UITextField {
    
    func addLeftPadding() { /// 텍스트 필드 왼쪽에 패딩값을 주기위한 함수입니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightView(view: UIView) {  /// 텍스트 필드 오른쪽에 뷰를 넣고, 패딩값을 주기 위한 함수입니다.
        let container = UIView()
        container.addSubview(view)
        
        container.snp.makeConstraints {
            $0.width.equalTo(view.snp.width).offset(12)
            $0.height.equalTo(view.snp.height)
        }
        view.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        self.rightView = container
        self.rightViewMode = .always
     }
}
```

- addLeftPadding: 커스텀 서치바의 왼쪽 여백을 줘 Placeholder 및 Text가 딱 붙지 않도록 하기 위한 함수입니다.
- addRightView: 커스텀 서치바의 Clear버튼을 넣기 위한 함수입니다.

- **UIActivityIndicatorView의 Extension**

```swift
import RxSwift
import RxCocoa

extension Reactive where Base: UIActivityIndicatorView {  
    
    public var isAnimating: Binder<Bool> { /// Rx로 ActivityIndicatorView의 Animate를 조금 더 간편하게 제어하기 위한 Extension입니다.
        return Binder(self.base) { activityIndicator, isActive in
            if isActive {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}
```

- 인디케이터뷰의 상태를 변경하기 위해서는 코드를 추가해주어야 합니다.  **`startAnimating()`**과 **`stopAnimating()`** 메소드 호출을 자동화함으로써, 반복적인 코드를 줄여줍니다.
- 또한, 저는 RxSwift를 통해 반응형 패러다임을 도입하였습니다. **`isAnimating`** 바인더를 통해 **`UIActivityIndicatorView`**의 상태도 반응형으로 관리할 수 있게 되므로, 일관된 프로그래밍 패턴을 유지할 수 있습니다.

# 🧐 과제에 대한 설명 및 트러블슈팅

## 서드파티 라이브러리 사용 이유

---

필수 라이브러리외 사용한 라이브러리

- **RxSwift**
    - 반응형 프로그래밍을 사용하여 효율적으로 **MVVM** 디자인 패턴을 적용하기 위해 RxSwift를 사용하였습니다.
        - MVVM의 ViewModel은 상태를 관리합니다. RxSwift를 사용하면, 이러한 상태를 Observable로 선언하고, 상태 변화를 구독하는 방식으로 관리할 수 있습니다. 이로 인해 상태 관리가 더 명확하고 예측 가능해집니다. 또한, 유저의 입력을 Observable 스트림으로 처리하여, ViewModel 내부의 로직에 쉽게 통합할 수 있습니다.
        - Rx를 통해 구독하면, ViewModel의 데이터 변화가 자동으로 View에 반영됩니다. Observable과 Binding을 통해 ViewModel의 상태 변화가 UI에 실시간으로 반영되어, 명령형 방식으로 UI를 업데이트하는 코드를 작성할 필요가 없어집니다.
- **Snapkit**
    - Then과 함께 UI부분의 코드를 간략하고, 직관적으로 작성할 수 있어서 사용하였습니다.
- **Kingfisher**
    - String타입의 URL을 간편하게 이미지로 보여주기 위해 사용하였습니다.

## 아키텍처 및 디자인 패턴 선정 이유

---

- **MVVM - C**
    - 기본적인 MVVM 패턴에 Coordinator패턴을 결합한 MVVM - C를 사용하였습니다.
        - 초기 설계 단계에서 `MVVM` 과 `Clean Architecture`를 결합하여 사용하는 방안을 고려했습니다. 그러나, 과제의 주요 요구 사항은 API를 통해 데이터를 가져와 사용자에게 리스트 형태로 보여주는 것이었습니다. 이러한 단순한 데이터 플로우에 유스케이스 레이어나 레포지토리 레이어 같은 추가적인 추상화를 도입하는 것은 구현을 복잡하게 할 뿐, 실질적인 가치는 없다고 판단하였습니다. 또한 프로젝트의 복잡성이 낮을 때는 오히려 이러한 패턴이 구조를 쓸데없이 복잡하게 만들어 가독성이 좋지 않는등, 비 효율적이라 판단이 들어, 일반적인 `MVVM` 패턴을 적용하였습니다.
        - `Coordinator` 패턴을 통해, 네비게이션 로직을 View로부터 분리하여, 책임의 분리와 네비게이션 로직이 한 곳(`Coordinator`)에 집중되어 있어, 변경 사항이 발생했을 때 해당 로직만 수정하면 되므로 유지보수가 용이해지기 때문에  효율적인 선택이라고 판단되었습니다. 더불어,  앱의 흐름을 더욱 명확하게 파악할 수 있게하여, `Coordinator` 패턴을 `MVVM` 패턴과 함께 사용했습니다.
- **In & Output**
    - 데이터 흐름을 체계적으로 관리하고 코드의 가독성을 향상시키위해 **`In & Output`** 패턴을 도입하였습니다
        - ViewModel에 대한 `Input`과 `Output`을 명확하게 정의함으로써, 어떤 데이터가 ViewModel로 들어오고 결과로 무엇이 나가는지 쉽게 이해할 수 있습니다. 이는 코드의 인터페이스를 명확히 하여,  코드를 보거나 수정할 때 발생할 수 있는 혼란을 최소화 할 수 있습니다, 또한, `입력(Input)`은 ViewModel로 들어오는 모든 데이터를 `캡슐화`하고, `출력(Output)`은 ViewModel에서 나오는 데이터를 정의합니다. 이를 통해  단방향 데이터 흐름을 강화하여 `ViewModel`에서 의도한 `Input`과 `Output`의 데이터 방향성을 `View`에서 오용하는 것을 방지할 수 있다. 이는 데이터의 상태를 추적하기 쉽게 만들어, 버그 발생 가능성을 줄여줍니다.
- **Singleton**
    - 깃허브 URL의 로그인을 통한 Code키값과 OAuth 토큰과 같이 공유되어야 하는 리소스의 경우 `싱글톤(Singleton)`패턴을 사용하면, 효율적으로 관리할 수 있습니다.
        - 오직 하나의 인스턴스만 존재함을 보장과 동시에, 전역 접근 포인트를 제공하기 때문에, 앱 내 어디서든 쉽게 토큰 정보에 접근할 수 있습니다. 이러한 장점과 더불어, `싱글톤(Singleton)` 패턴의 복잡성과 전역 의존성이 문제가 되지 않는 범위라 생각하여 `싱글톤(Singleton)` 패턴을 적용하였습니다.

## 고민했던 문제

---

- **UI/UX**
    - **깃허브 로그인을 통한 OAuth 토큰 발행 시, 로그인 화면 구성에 대한 고민 및 토큰 만료 시, 재로그인**
        - OAuth토큰을 발행하기 위해서는 깃허브 URL을 통한 깃허브 로그인이 필수입니다. 그렇기 때문에, 초기 로그인 화면을 구성하는것이 사용자 경험적으로 좋다고 판단하여, 로그인 화면을 구성하였습니다. 그런데, 앱을 시작할 때 마다, 로그인은 하는 것은 좋지 않은 UX라 생각하여, 로그인 정보가 있는 사용자는 바로 검색화면으로 이동하게 했습니다.
        - 토큰 만료시, 유저에게 재로그인을 통해 토큰을 새로 발급 받아야합니다. 토큰 만료시점은 유저가 검색을 했을 때 부터 알 수 있습니다. 검색하고 난 뒤, 로그인 화면으로 보내서 다시 플로우를 시작하면, 유저가 피로감을 느끼고 앱을 중도 이탈 할 수 도 있다고 생각하여, 검색화면에서 바로 팝업메시지를 띄워 재로그인을 유도한뒤, 로그인을 통한 토큰을 새롭게 발급하면 다시, 서치바에 이전에 검색하려던 Text와 함께 이전화면으로 돌아가게 하였습니다. 이로 인해 유저는 바로 마무리하지 않았던 검색을 검색버튼하나만으로도 다시 할 수 있게 하였습니다.
    - **Github User Serach API로 정보를 가져와 리스트로 UI에 보여줄 시, 0.5초간 딜레이 발생OAuth**
        - 사용자가 검색을 하면 API에 대한 응답시간이 0.5초 정도 걸려, 그 시간동안 아무런 표시가 없어 유저가 혼란을 느낄 수 있다 판단하여, 인디게이터 뷰를 통해, 검색이 진행중임을 나타냈습니다.
    - **리스트 선택 시, 단순히 URL 이동을 통해, 웹 브라우저로만 보여줄 시, 다음 인터렉션에대한 혼란**
        - 리스트 선택 후, URL을 이동하면 단순히 화면전체에 URL을 통해 깃허브로 가는 방식이였습니다. 이 경우 뒤로가기를 통해 다시 검색을 하고싶은 경우에는 유저가 많은 혼란을 느낄 수 있겠다 판단 하였습니다. 그래서 웹뷰를 통해 URL을 보여주고 상단에 네비게이션 바를 통해 뒤로가기 버튼 및 유저의 닉네임을 네비게이션바 타이틀에 위치시켜, 현재 어떤 유저의 깃허브인지와 뒤로가기를 버튼을 유저에게 인식하게하여, 혼란을 최소화 하였습니다.
- **로직**
    - **깃허브 OAuth 토큰 만료 시점에 대한 정보가 없음**
        - 깃허브 OAuth의 토큰의 응답값에는 만료시점에 대한 응답이 없었습니다. 검색 결과 8시간 정도 된다고 대략적인 추측에 대한 결과만 있었을 뿐입니다. 실제로, 디바이스에서 하루지난 뒤, 같은 토큰으로 요청을 하면 `401`에러를 반환했습니다. 그래서 `401` 에러를 반환하면, 토큰을 만료되었음을 인식하고 다시 토큰을 요청하는 방식의 로직을 작성하였습니다.

## 트러블 슈팅

---

- 토큰 재요청하는 로직에서 `401` 에러 반환 시, 스트림이 끊김
    - 에러 반환 시, 스트림이 끊기는걸 인지하지 못한 채로, Error를 반환하면 커스텀 에러 구조체를 통해 분기 처리 후, `401`  에러 반환 시, 다음 로직을 실행하는 로직을 구성하였습니다. 구성한 로직이 에러를 반환 후, 작동하지 않자, 디버깅을 한 토대로, 스트림이 끊겼다는것을 알아챘습니다. 그리하여, **스트림이 끊기지 않게 Catch문을 통해 Error Handling**을 하여 문제를 해결하였습니다.
    - 기존코드
    
    ```swift
           searchTrigger /// 검색 버튼의 입력을 감지하고 API 요청하는 로직입니다.
                .debug("Search Trigger")
                .flatMapLatest { [weak self] text -> Observable<UserListDTO> in
                    print(text)
                    guard let self = self else { return Observable.empty() }
                    return self.service.fetchUserList(userName: text)
                        .asObservable()
                        .do(onSubscribe: { self.indicatorVisible.accept(true) }) // 검색 시작 시, 인디게이터 상태 제어
                }
                .subscribe(onNext: {  [weak self] userListDTO in  //검색 완료 시,
                    
                    self?.searchResults.onNext(userListDTO.items)
                    self?.totalUserCount.onNext(userListDTO.totalCount)
                    self?.indicatorVisible.accept(false)
                    
                }, onError: { [weak self] error in // 검색 시, 에러 발생
                    if let apiError = error as? APIError {
                           switch apiError {
                           case .unauthorized:  // 401에러 발생 시, 로그인 재 요청
                               self?.coordinator?.pushRequestToken()
                               self?.indicatorVisible.accept(false)
                               self?.retryWithTokenRefresh()
                           default:
                               print("Other Error: \(apiError)")
                           }
                       } else {
                           print("Error: \(error.localizedDescription)")
                       }
                })
                .disposed(by: disposeBag)
    ```
    

- 리팩토링한 코드
    
    ```swift
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
    ```
    

***참고 자료**

[1] [RxSwift를 이용한 백그라운드 감지](https://eeyatho.tistory.com/24)

[2] [error 반환시에도 스트림유지](https://medium.com/@kyuchul2/test-cf32df9999d4)
