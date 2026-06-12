//
//  AppDelegate.swift
//  Saion
//
//  Created by 신정욱 on 5/31/26.
//

import UIKit
import DesignSystem

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIView.swizzleLayoutSubviews()
        return true
    }
}


