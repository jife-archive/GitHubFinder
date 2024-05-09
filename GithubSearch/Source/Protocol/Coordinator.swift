//
//  Coordinator.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

// 기본 Coordinator Protocol
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
extension Coordinator { /// Coordinator의 네비게이션 스택을 효율적으로 관리하기 위한 Extension입니다.
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
