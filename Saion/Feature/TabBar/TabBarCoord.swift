//
//  TabBarCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import Combine
import UIKit

import CasePaths

import Navigation

final class TabBarCoord: Coordinator {
    
    // MARK: Start
    
    /// 탭바 화면 초기화
    func start() {
        let vm = TabBarVM(circleRepo: DefaultCircleRepo())
        let vc = TabBarVC(vm: vm)
        
        // 선택한 서클이 바뀌면 각 탭의 화면 흐름을 새 서클 기준으로 재구성
        vm.$state.compactMap(\.currentCircleID).removeDuplicates()
            .sink { [weak self] _ in self?.setUpTabCoordinators(in: vc) }
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
    
    /// 기존 탭 흐름을 정리하고 탭별 코디네이터를 새로 구성
    private func setUpTabCoordinators(in tabBarVC: TabBarVC) {
        // 서클 변경 전에 표시 중인 모달과 기존 탭 코디네이터의 생명주기를 정리
        navigation.dismiss(animated: true)
        children.removeAll()
        
        // 홈 탭 구성
        let homeCoord = HomeCoord(navigation: .init())
        homeCoord.navigation.tabBarItem = UITabBarItem(
            title: "홈",
            image: .house,
            tag: 0
        )
        store(child: homeCoord)
        homeCoord.start()
        
        // 일정 탭 구성
        let scheduleCoord = ScheduleCoord(navigation: .init())
        scheduleCoord.navigation.tabBarItem = UITabBarItem(
            title: "일정",
            image: .calendarHeart,
            tag: 1
        )
        store(child: scheduleCoord)
        scheduleCoord.start()
        
        // 마이페이지 탭 구성
        let myPageCoord = MyPageCoord(navigation: .init())
        myPageCoord.navigation.tabBarItem = UITabBarItem(
            title: "마이",
            image: .user,
            tag: 2
        )
        store(child: myPageCoord)
        myPageCoord.start()
        
        // 각 코디네이터의 내비게이션을 탭바 루트 화면으로 연결
        tabBarVC.setViewControllers(
            [
                homeCoord.navigation,
                scheduleCoord.navigation,
                myPageCoord.navigation
            ],
            animated: true
        )
        
        // 서클이 변경되면 홈 탭부터 다시 시작
        tabBarVC.selectedIndex = 0
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
