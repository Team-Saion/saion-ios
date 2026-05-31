//
//  SceneDelegate.swift
//  Saion
//
//  Created by 신정욱 on 5/31/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    // MARK: Methods
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // TODO: 메인화면 진입 로직 추가해야 함
        
        window?.makeKeyAndVisible()
    }
}

