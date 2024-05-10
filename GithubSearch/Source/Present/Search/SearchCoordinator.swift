//
//  SearchCoordinator.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var delegate: CoordinatorDelegate?
    private let urlConstants = UrlConstants()

    func start() {
        let vc = SearchViewController(viewModel: SearchViewModel(service: Service(), coordinator: self))
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushUserDetail(userUrl: String, userName: String) {
        let vc = UserDetailViewController(url: userUrl)
        navigationController.isNavigationBarHidden = false
        vc.navigationItem.title = userName
        navigationController.navigationBar.tintColor = .black
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushRequestToken() {
        let alert = UIAlertController(title: "로그인 필요", message: "세션이 만료되었습니다. 다시 로그인해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            if let url = URL(string: "\(self?.urlConstants.GitHubURL ?? "")\(self?.urlConstants.ClientId ?? "")") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(confirmAction)

        navigationController.visibleViewController?.present(alert, animated: true)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
