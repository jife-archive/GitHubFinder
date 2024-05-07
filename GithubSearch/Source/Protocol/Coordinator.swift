//
//  Coordinator.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: any Coordinator)
}
protocol Coordinator: AnyObject {
    
    var childCoordinators: [any Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    func start()
    func finish()
}
extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
    
    func dismiss(animated: Bool = false) {
        navigationController.presentedViewController?.dismiss(animated: animated)
    }
    
    func popupViewController(animated: Bool = false) {
        navigationController.popViewController(animated: animated)
    }
}
