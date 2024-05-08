//
//  UserDetailViewController.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit
import WebKit

import RxSwift
import RxCocoa

final class UserDetailViewController: BaseViewController {
    //MARK: - UI
    
    private let wkWebView = WKWebView()
    
    //MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    override func addView() {
        self.view.addSubview(wkWebView)
    }
    
    override func layout() {
        wkWebView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
