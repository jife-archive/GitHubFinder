//
//  AppCoordinator.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var delegate: CoordinatorDelegate?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        let coordinator = LoginCoordinator(paraentCoordinator: self, navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
