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
        let vc = LoginViewController(viewModel: LoginViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
    init(paraentCoordinator: AppCoordinator?, navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
