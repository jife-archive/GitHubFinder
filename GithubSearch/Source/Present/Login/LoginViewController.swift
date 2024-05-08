//
//  LoginViewController.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    //MARK: - Properties

    private let viewModel : LoginViewModel
    private var disposeBag = DisposeBag()
    
    //MARK: - UI
    
    private let titleLabel = UILabel().then {
        $0.text = "앱을 시작하기 위해서,\n깃허브 로그인을 부탁드리겠습니다."
        $0.font = .systemFont(ofSize: 15,weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    private let loginBtn = UIButton().then {
        $0.setTitle("깃허브로 로그인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .black
    }
    
    //MARK: - LifeCycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    override func addView() {
        [titleLabel, loginBtn].forEach {
            self.view.addSubview($0)
        }
    }

    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        loginBtn.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
    }
    
    override func binding() {
        let input = LoginViewModel.Input(loginTap: loginBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)
        
        output.url
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: {  url in
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
    }
}
