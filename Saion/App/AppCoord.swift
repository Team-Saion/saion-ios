//
//  AppCoord.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Combine
import UIKit

import CasePaths
import SnapKit

final class AppCoord: Coordinator {
    
    // MARK: Properties
    
    private weak var window: UIWindow?
    
    // MARK: Life Cycle
    
    init(window: UIWindow?) {
        self.window = window
        super.init(navigation: .init())
    }
    
    // MARK: Start
    
    func start() {
        // 주어진 인증 상태에 따라, 탭바/로그인 화면 분기처리
        AuthManager.shared.authStatePublisher
            .map { $0.is(\.signedIn) }
            .removeDuplicates() // 코디네이터 중복 시작 차단
            .sink { [weak self] in $0 ? self?.startTabBar() : self?.startLogin() }
            .store(in: &cancellables)
    }
    
    private func startTabBar() {
        // 전환 전에 기존 자식 코디네이터 정리
        children.removeAll()
        // 새 코디네이터의 네비게이션을 루트로 설정
        let coord = TabBarCoord(navigation: .init())
        setRootWithAnimation(coord.navigation)
        store(child: coord)
        coord.start()
    }
    
    private func startLogin() {
        // 전환 전에 기존 자식 코디네이터 정리
        children.removeAll()
        // 새 코디네이터의 네비게이션을 루트로 설정
        let coord = AuthCoord(navigation: .init())
        setRootWithAnimation(coord.navigation)
        store(child: coord)
        coord.start()
    }
    
    // MARK: Private Helpers
    
    /// 크로스 디졸브 효과와 함께 루트 뷰컨트롤러를 교체
    private func setRootWithAnimation(_ vc: UIViewController) {
        guard let window else { return }
        // 처음 루트를 세팅할 때는 즉시 교체
        guard window.rootViewController != nil
        else { window.rootViewController = vc; return }
        
        UIView.transition(
            with: window,
            duration: 0.32,
            options: [
                .transitionCrossDissolve,
                .allowAnimatedContent,
                .curveEaseInOut
            ]
        ) {
            window.rootViewController = vc
        }
    }
}
