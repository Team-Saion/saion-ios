//
//  AppDelegate.swift
//  Saion
//
//  Created by 신정욱 on 5/31/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 인증 상태 매니저 초기화
        AuthManager.shared.store.send(.appDidLaunch)
        return true
    }
}
