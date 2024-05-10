//
//  ActivityIndicatorView+Extension.swift
//  GithubSearch
//
//  Created by 최지철 on 5/10/24.
//

import UIKit

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
