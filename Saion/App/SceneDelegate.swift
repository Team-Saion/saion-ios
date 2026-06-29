//
//  SceneDelegate.swift
//  Saion
//
//  Created by 신정욱 on 5/31/26.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Properties
    
    var mainWindow: UIWindow?
    var appCoord: AppCoord?
    
    // MARK: Methods
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 메인 윈도우 설정
        let mainWindow = UIWindow(windowScene: windowScene)
        mainWindow.makeKeyAndVisible()
        self.mainWindow = mainWindow
        
        // 루트 뷰 컨트롤러는 AppCoord 내부에서 설정
        appCoord = AppCoord(window: mainWindow)
        appCoord?.start()
    }
    
    /// 딥링크나 유니버설 링크를 처리하는 메서드
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        // 들어온 URL 정보가 있는지 확인
        guard let url = URLContexts.first?.url else { return }
        
        // 카카오톡 앱을 통한 인증 후 돌아왔을 때, SDK에 전달해 로그인을 완료
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
}
