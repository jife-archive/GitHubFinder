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
    private let clearBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        $0.tintColor = .black
    }
    private let searchBar = UITextField().then {
        $0.placeholder = "찾으실 유저를 입력해주세요."
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.rightViewMode = .always
        $0.autocapitalizationType = .none
        $0.returnKeyType = .search
        $0.addLeftPadding()
    }
    private let emptyView = EmptyView().then {
        $0.isHidden = true
    }
    private let userInfoTableView = UITableView(frame: CGRect.zero, style: .plain).then{
        $0.backgroundColor = .clear
        $0.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.identifier)
        $0.separatorInset = .zero
    }
    private var activityIndicator = UIActivityIndicatorView(style: .large)

    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

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
        searchBar.addRightView(view: clearBtn)
        [searchBar, userInfoTableView, activityIndicator].forEach {
            self.view.addSubview($0)
        }
        userInfoTableView.addSubview(emptyView)
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
        clearBtn.snp.makeConstraints {
            $0.width.height.equalTo(25)
        }
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(12)
        }
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func binding() {
        let input = SearchViewModel.Input(
            inputText: searchBar.rx.text.orEmpty.asObservable(),  
            searchTapped: searchBar.rx.controlEvent(.editingDidEndOnExit).asSignal(onErrorSignalWith: .empty()),
            didSelectRowAt: userInfoTableView.rx.modelSelected(UserInfo.self).asSignal(), 
            clearTapped: clearBtn.rx.tap.asSignal()
        )

        let output = viewModel.transform(input: input)
        
        output.clearBtnVisible
            .bind(to: clearBtn.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.searchImgVisible
            .bind(to: searchImg.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.searchText
            .bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)
        
        userInfoTableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.searchResult
            .bind(to: userInfoTableView.rx.items(cellIdentifier: UserListTableViewCell.identifier,
                                                 cellType: UserListTableViewCell.self))
        {  index, item, cell in
            cell.configure(name: item.name, url: item.url, img: item.imgURL)
            cell.selectionStyle = .none
        }
        .disposed(by: disposeBag)
        
        output.totalSearchCount
            .map { $0 != 0 }
            .bind(onNext: {  [weak self]  res in
                self?.emptyView.isHidden = res
            })
            .disposed(by: disposeBag)
        
        output.indicatorVisible
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
// MARK: - Extension
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
