//
//  TabBarCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import Combine
import UIKit

import CombineCocoa

import DesignSystem
import Navigation

final class TabBarCoord: Coordinator {
    
    // MARK: Start
    
    /// 탭바 화면 초기화
    func start() {
        /// 홈 코디네이터
        let homeCoord = HomeCoord(navigation: .init())
        homeCoord.navigation.tabBarItem = UITabBarItem(
            title: "홈",
            image: .house,
            tag: 0
        )
        store(child: homeCoord)
        homeCoord.start()
        
        /// 일정 코디네이터
        let scheduleCoord = ScheduleCoord(navigation: .init())
        scheduleCoord.navigation.tabBarItem = UITabBarItem(
            title: "일정",
            image: .calendarHeart,
            tag: 1
        )
        store(child: scheduleCoord)
        scheduleCoord.start()
        
        /// 마이페이지 코디네이터
        let myPageCoord = MyPageCoord(navigation: .init())
        myPageCoord.navigation.tabBarItem = UITabBarItem(
            title: "마이",
            image: .user,
            tag: 2
        )
        store(child: myPageCoord)
        myPageCoord.start()
        
        let vc = TabBarVC()
        vc.setViewControllers(
            [
                homeCoord.navigation,
                scheduleCoord.navigation,
                myPageCoord.navigation
            ],
            animated: false
        )
        
        // 주어진 인덱스로 탭 전환
        vc.defaultTabBar.selectedIndexPublisher
            .prepend(0) // 초기 탭 인덱스
            .sink { [weak vc] index in
                // 가입한 서클이 없으면 일정 탭 진입을 차단
                if index == 1, CurrentCircleStore.shared.currentCircleID == nil {
                    ToastCenter.shared.present(message: "서클에 가입하면 일정을 확인할 수 있어요.")
                    return
                }
                vc?.selectedIndex = index
            }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
}
