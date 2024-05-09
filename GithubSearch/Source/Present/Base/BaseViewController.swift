//
//  BaseViewController.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    func layout() {}
    func configure() {}
    func addView() {}
    func binding() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.configure()
        self.addView()
        self.layout()
        self.binding()
    }
}
extension Reactive where Base: UIViewController {   /// Rx를 이용해, 생명주기를 효율적으로 관리하기 위한 Extension입니다.
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { _ in () }
        return ControlEvent(events: source)
    }
}
