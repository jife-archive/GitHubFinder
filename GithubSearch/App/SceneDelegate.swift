//
//  SceneDelegate.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: (any Coordinator)?
    let navigaitonController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        window = UIWindow(windowScene: windowScene)
        window!.windowScene = windowScene


        if TokenManager.shared.isTokenValid() {
            // 토큰이 유효한 경우, 메인 화면으로 직접 이동
            appCoordinator = SearchCoordinator(navigationController: navigaitonController)
            appCoordinator?.start()
        } else {
            // 토큰이 유효하지 않은 경우, 로그인 화면으로 이동
            appCoordinator = AppCoordinator(navigationController: navigaitonController)
            appCoordinator?.start()
        }
    
        window?.rootViewController = navigaitonController
        window?.makeKeyAndVisible()

    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
         if let url = URLContexts.first?.url {
             let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
             print(code)
             TokenManager.shared.saveCodeKey(code)
         }
     }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

