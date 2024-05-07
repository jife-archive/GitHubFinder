//
//  SearchViewController.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    
    //MARK: - Properties
    
    private let viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    
    //MARK: - UI
    
    private let searchImg = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .black
    }
    private let searchBar = UITextField().then {
        $0.placeholder = "찾으실 유저를 입력해주세요."
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.addLeftPadding()
    }
    private let userInfoTableView = UITableView(frame: CGRect.zero, style: .grouped).then{
        $0.backgroundColor = .clear
        $0.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.identifier)
        $0.separatorInset = .zero
    }
    
    //MARK: - LifeCycle

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    override func configure() {
        userInfoTableView.delegate = self
    }
    
    override func addView() {
        searchBar.addSubview(searchImg)
        [searchBar, userInfoTableView].forEach {
            self.view.addSubview($0)
        }
    }

    override func layout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        searchImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
            $0.trailing.equalToSuperview().inset(12)
        }
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(12)
        }
    }
    
    override func binding() {
        Observable.just([1,2,3])
            .bind(to: userInfoTableView.rx.items(cellIdentifier: UserListTableViewCell.identifier, cellType: UserListTableViewCell.self))
        {  index, item, cell in
            
        }
        .disposed(by: disposeBag)
    }
}
// MARK: - Extension
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
