//
//  HomeCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

import Combine
import UIKit

import CombineCocoa

import Navigation

final class HomeCoord: Coordinator {
    
    // MARK: Subjects
    
    /// 가입 서클 변경 서브젝트(출력)
    private let joinedCirclesDidChangeSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Start
    
    func start(circleID: String?) {
        let vc: UIViewController
        
        if let circleID {
            let vm = HomeDI.shared.makeCircleOverviewVM(circleID: circleID)
            let overviewVC = CircleOverviewVC(vm: vm)
            vc = overviewVC
            
            // 일정 생성 화면으로 이동
            overviewVC.createSchedulePublisher
                .sink { [weak self] in self?.presentCreateScheduleVC(circleID: circleID) }
                .store(in: &overviewVC.cancellables)
            
            // 전체 구성원 목록 화면으로 이동
            overviewVC.showAllMembersTapPublisher
                .sink { [weak self] in self?.pushMemberListVC(circleID: circleID) }
                .store(in: &overviewVC.cancellables)
            
            // 알림 목록 화면으로 이동
            overviewVC.notificationTapPublisher
                .sink { [weak self] in self?.pushInboxVC() }
                .store(in: &overviewVC.cancellables)
            
        } else {
            let entryVC = CircleEntryVC()
            vc = entryVC
            
            // 서클 참여 화면으로 이동
            entryVC.joinButton.tapPublisher
                .sink { [weak self] in self?.presentJoinCircle() }
                .store(in: &entryVC.cancellables)
            
            // 서클 생성 화면으로 이동
            entryVC.createButton.tapPublisher
                .sink { [weak self] in self?.presentCircleInitializationVC() }
                .store(in: &entryVC.cancellables)
        }
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
    
    // MARK: Routing
    
    /// 서클 참여 흐름 시작
    private func presentJoinCircle() {
        let coord = JoinCircleCoord(navigation: .init())
        coord.navigation.modalPresentationStyle = .fullScreen
        addChild(coord)
        coord.start()
        
        // 서클 참여 완료 이벤트 외부로 전달
        coord.joinCircleCompletedPublisher
            .sink { [weak self] in self?.joinedCirclesDidChangeSubject.send(()) }
            .store(in: &coord.cancellables)
        
        navigation.present(coord.navigation, animated: true)
    }
    
    /// 서클 생성 화면으로 이동
    func presentCircleInitializationVC() {
        let vc = CircleInitializationVC()
        vc.modalPresentationStyle = .fullScreen
        
        // 서클 생성 완료 이벤트 외부로 전달
        vc.circleCreatedPublisher
            .sink { [weak self] in self?.joinedCirclesDidChangeSubject.send(()) }
            .store(in: &vc.cancellables)
        
        // 화면 전환
        navigation.present(vc, animated: true)
    }
    
    /// 일정 생성 화면으로 이동
    private func presentCreateScheduleVC(circleID: String) {
        let vm = ScheduleDI.shared.makeCreateScheduleVM(circleID: circleID)
        let vc = CreateScheduleVC(vm: vm)
        vc.modalPresentationStyle = .fullScreen
        
        // 화면 전환
        navigation.present(vc, animated: true)
    }
    
    /// 전체 구성원 목록 화면으로 이동
    func pushMemberListVC(circleID: String) {
        let vm = HomeDI.shared.makeMemberListVM(circleID: circleID)
        let vc = MemberListVC(vm: vm)
        vc.hidesDefaultTabBarWhenPushed = true
        
        navigation.pushViewController(vc, animated: true)
    }
    
    /// 알림 목록 화면으로 이동
    func pushInboxVC() {
        let vc = InboxVC()
        vc.hidesDefaultTabBarWhenPushed = true
        
        navigation.pushViewController(vc, animated: true)
    }
    
    // MARK: Reactive Interface
    
    /// 가입 서클 변경 퍼블리셔
    var joinedCirclesDidChangePublisher: AnyPublisher<Void, Never> {
        joinedCirclesDidChangeSubject.eraseToAnyPublisher()
    }
}
