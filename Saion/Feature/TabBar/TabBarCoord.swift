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
    
    // MARK: Subjects
    
    /// 가입 서클 변경 서브젝트(출력)
    private let joinedCirclesDidChangeSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Start
    
    /// 탭바 화면 초기화
    func start() {
        let vm = TabBarVM(circleRepo: DefaultCircleRepo())
        let vc = TabBarVC(vm: vm)
        
        // 선택한 서클이 바뀌면 각 탭의 화면 흐름을 새 서클 기준으로 재구성
        vm.effect.compactMap { $0[case: \.setUpTabCoordinators] }.removeDuplicates()
            .sink { [weak self, weak vc] in self?.setUpTabCoords(in: vc, circleID: $0) }
            .store(in: &vc.cancellables)
        
        // 서클 참여나 생성 후 가입 서클을 다시 조회
        joinedCirclesDidChangeSubject
            .sink { [weak vm] in vm?.send(.joinedCirclesDidChange) }
            .store(in: &vc.cancellables)
        
        // 탭바가 나타난 시점부터 대기 중이거나 새로 들어오는 딥링크 처리
        vc.viewDidAppearPublisher.prefix(1)
            .flatMap { DeepLinksCenter.shared.$pending }
            .compactMap { $0?[case: \.routeJoinCircle] }
            .sink { [weak self] invitationCode in
                DeepLinksCenter.shared.pending = nil
                self?.startJoinCircleCoord(invitationCode: invitationCode)
            }
            .store(in: &vc.cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
    
    /// 기존 탭 흐름을 정리하고 탭별 코디네이터를 새로 구성
    private func setUpTabCoords(in tabBarVC: TabBarVC?, circleID: String?) {
        // 서클 변경 전에 표시 중인 모달과 기존 탭 코디네이터의 생명주기를 정리
        navigation.dismiss(animated: true)
        removeAllChildren()
        
        let homeCoord = startHomeCoord(circleID: circleID)
        let scheduleCoord = startScheduleCoord(circleID: circleID)
        let myPageCoord = startMyPageCoord()
        
        // 각 코디네이터의 내비게이션을 탭바 루트 화면으로 연결
        tabBarVC?.setViewControllers(
            [
                homeCoord.navigation,
                scheduleCoord.navigation,
                myPageCoord.navigation
            ],
            animated: true
        )
        // 서클이 변경되면 홈 탭부터 다시 시작
        tabBarVC?.selectedIndex = 0
    }
    
    /// 홈 탭 코디네이터 시작
    private func startHomeCoord(circleID: String?) -> HomeCoord {
        let coord = HomeCoord(navigation: .init())
        coord.navigation.tabBarItem = UITabBarItem(
            title: "홈",
            image: .house,
            tag: 0
        )
        addChild(coord)
        coord.start(circleID: circleID)
        
        // 홈에서 발생한 가입 서클 변경 이벤트를 탭바 갱신 흐름으로 전달
        coord.joinedCirclesDidChangePublisher
            .sink { [weak self] in self?.joinedCirclesDidChangeSubject.send() }
            .store(in: &coord.cancellables)
        
        return coord
    }
    
    /// 일정 탭 코디네이터 시작
    private func startScheduleCoord(circleID: String?) -> ScheduleCoord {
        let coord = ScheduleCoord(navigation: .init())
        coord.navigation.tabBarItem = UITabBarItem(
            title: "일정",
            image: .calendarHeart,
            tag: 1
        )
        addChild(coord)
        if let circleID { coord.start(circleID: circleID) }
        
        return coord
    }
    
    /// 마이페이지 탭 코디네이터 시작
    private func startMyPageCoord() -> MyPageCoord {
        let coord = MyPageCoord(navigation: .init())
        coord.navigation.tabBarItem = UITabBarItem(
            title: "마이",
            image: .user,
            tag: 2
        )
        addChild(coord)
        coord.start()
        
        return coord
    }
    
    // MARK: Routing
    
    /// 서클 참여 흐름 시작
    private func startJoinCircleCoord(invitationCode: String) {
        let coord = JoinCircleCoord(navigation: .init())
        coord.navigation.modalPresentationStyle = .fullScreen
        
        // 딥링크를 통한 참여 완료 후 가입 서클 갱신
        coord.joinCircleCompletedPublisher
            .sink { [weak self] in self?.joinedCirclesDidChangeSubject.send() }
            .store(in: &coord.cancellables)
        
        addChild(coord)
        coord.startFromDeepLink(invitationCode: invitationCode)
        navigation.present(coord.navigation, animated: true)
    }
}
