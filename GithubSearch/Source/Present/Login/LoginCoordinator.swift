//
//  LoginCoordinator.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var delegate: CoordinatorDelegate?
    
    func start() {
        let vm = LoginViewModel(coordinator: self, service: Service(), urlConstants: UrlConstants())
        let vc = LoginViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushMain() {
        let coordinator = SearchCoordinator(navigationController: navigationController)
        navigationController.isNavigationBarHidden = true
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    init(paraentCoordinator: AppCoordinator?, navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
