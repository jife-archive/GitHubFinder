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
    //MARK: - Properties
    
    private var url: String

    //MARK: - UI
    
    private let wkWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private var activityIndicator = UIActivityIndicatorView(style: .large)

    //MARK: - LifeCycle
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        loadWebPage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    override func configure() {
        wkWebView.navigationDelegate = self
    }
    
    override func addView() {
        self.view.addSubview(wkWebView)
        self.view.addSubview(activityIndicator)

    }
    
    override func layout() {
        wkWebView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func loadWebPage() {
        
        guard let url = URL(string: self.url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        self.wkWebView.load(request)
    }
}
// MARK: - Extension
extension UserDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
