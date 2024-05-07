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
    
    func start() {
        let vc = SearchViewController(viewModel: SearchViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
