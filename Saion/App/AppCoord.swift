//
//  AppCoord.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Combine
import UIKit

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
            .sink { [weak self] in
                switch $0 {
                case .unknown:  break
                case .valid:    self?.startTabBar()
                case .invalid:  self?.startLogin()
                }
            }
            .store(in: &cancellables)
    }
    
    private func startTabBar() {
        print("🥗 startTabBar 실행(되어야 함..)")
//        // 전환 전에 기존 자식 코디네이터 정리
//        children.removeAll()
//        // 새 코디네이터의 네비게이션을 루트로 설정
//        let coord = TabBarCoord(navigation: .init())
//        setRootWithAnimation(coord.navigation)
//        store(child: coord)
//        coord.start()
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
    
    /// 트랜지션 효과와 함께 루트 뷰컨트롤러 설정
    /// - 블러 인 -> 크로스 디졸브 -> 블러 아웃 순서로 루트 교체
    private func setRootWithAnimation(_ vc: UIViewController) {
        guard let window else { return }
        // 처음 루트를 세팅할 때는 즉시 교체
        guard window.rootViewController != nil
        else { window.rootViewController = vc; return }
        
        // 1) 블러 레이어 준비
        let blurView = UIVisualEffectView(effect: nil)
        window.addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // 2) 블러 인
        UIView.animate(withDuration: 0.15) {
            blurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
            
        } completion: { _ in
            // 3) 루트 화면 크로스 디졸브 전환
            UIView.transition(
                with: window,
                duration: 0.3,
                options: [
                    .transitionCrossDissolve,
                    .allowAnimatedContent,
                    .curveEaseInOut
                ]
            ) {
                window.rootViewController = vc
                
            } completion: { _ in
                // 4) 블러 아웃 후 블러 레이어 제거
                UIView.animate(withDuration: 0.2) {
                    blurView.effect = nil
                    
                } completion: { _ in
                    blurView.removeFromSuperview()
                }
            }
        }
    }
}
