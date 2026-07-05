//
//  TabBarCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import Combine
import UIKit

import CombineCocoa

import Navigation

final class TabBarCoord: Coordinator {
    
    // MARK: Start
    
    /// 탭바 화면 초기화
    func start() {
        /// 홈 코디네이터
        let homeVC = NavigationController(rootViewController: HomeVC())
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: .house,
            tag: 0
        )
        
        let vc = TabBarVC()
        vc.setViewControllers(
            [homeVC],
            animated: false
        )
        
        // 주어진 인덱스로 탭
        vc.defaultTabBar.selectedIndexPublisher
            .prepend(0) // 초기 탭 인덱스
            .sink { [weak vc] in vc?.selectedIndex = $0 }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
}
