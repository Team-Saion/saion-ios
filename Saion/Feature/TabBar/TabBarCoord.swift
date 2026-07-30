//
//  TabBarCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import Combine
import UIKit

import CasePaths
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
        
        let vc = TabBarVC(
            homeVC: homeCoord.navigation,
            scheduleVC: scheduleCoord.navigation,
            myPageVC: myPageCoord.navigation
        )
        
        //        vc.setViewControllers(
        //            [
        //                homeCoord.navigation,
        //                scheduleCoord.navigation,
        //                myPageCoord.navigation
        //            ],
        //            animated: false
        //        )
        
        // 주어진 인덱스로 탭 전환
        vc.defaultTabBar.selectedIndexPublisher
            .prepend(0) // 초기 탭 인덱스
            .sink { [weak vc] index in
                // 가입한 서클이 없으면 일정 탭 진입을 차단
                if index == 1, UserSessionStore.shared.currentCircle == nil {
                    ToastCenter.shared.present(message: "서클에 가입하면 일정을 확인할 수 있어요.")
                    return
                }
                vc?.selectedIndex = index
            }
            .store(in: &cancellables)
        
        // 탭바가 나타난 시점부터 대기 중이거나 새로 들어오는 딥링크 처리
        vc.viewDidAppearPublisher
            .prefix(1)
            .flatMap { DeepLinksCenter.shared.$pending }
            .compactMap { $0?[case: \.routeJoinCircle] }
            .sink { [weak self] invitationCode in
                guard let self else { return }
                DeepLinksCenter.shared.pending = nil
                self.presentJoinCircle(invitationCode: invitationCode)
            }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
    
    /// 서클 참여 흐름 시작
    private func presentJoinCircle(invitationCode: String) {
        let coord = JoinCircleCoord(navigation: .init())
        coord.navigation.modalPresentationStyle = .fullScreen
        
        // 참여 흐름 종료 시 자식 코디네이터 해제
        coord.didFinishPublisher
            .sink { [weak self, weak coord] in self?.free(child: coord) }
            .store(in: &coord.cancellables)
        
        store(child: coord)
        coord.start(invitationCode: invitationCode)
        navigation.present(coord.navigation, animated: true)
    }
}
