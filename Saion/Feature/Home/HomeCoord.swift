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
    
    // MARK: Start
    
    func start() {
        let vc = HomeVC()
        
        // 서클 생성 화면으로 이동하고, 생성 완료 시 목록 갱신
        vc.entryVC.createButton.tapPublisher
            .compactMap { [weak self] in self?.presentCircleInitializationVC() }
            .switchToLatest()
            .sink { [weak vc] in vc?.refresh() }
            .store(in: &vc.cancellables)
        
        // 일정 생성 화면으로 이동, 생성 완료 시 화면 갱신
        vc.overviewVC.createSchedulePublisher
            .compactMap { [weak self] in self?.presentCreateScheduleVC() }
            .switchToLatest()
            .sink { [weak vc] in vc?.overviewVC.refresh() }
            .store(in: &vc.cancellables)
        
        // 전체 구성원 목록 화면으로 이동
        vc.overviewVC.showAllMembersTapPublisher
            .sink { [weak self] in self?.pushMemberListVC() }
            .store(in: &vc.cancellables)
        
        // 알림 목록 화면으로 이동
        vc.navigationBar.notificationButton.tapPublisher
            .sink { [weak self] in self?.pushInboxVC() }
            .store(in: &vc.cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
    
    /// 서클 생성 화면으로 이동
    func presentCircleInitializationVC() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let vc = CircleInitializationVC()
            vc.modalPresentationStyle = .fullScreen
            
            // 서클 생성 완료 시, 화면 닫고 이벤트 외부로 전달
            vc.circleCreatedPublisher
                .sink { [weak vc] in
                    vc?.dismiss(animated: true)
                    promise(.success(()))
                }
                .store(in: &vc.cancellables)
            
            // 화면 전환
            self?.navigation.present(vc, animated: true)
        } }
        .eraseToAnyPublisher()
    }
    
    /// 일정 생성 화면으로 이동
    func presentCreateScheduleVC() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let vm = ScheduleDI.shared.makeCreateScheduleVM()
            let vc = CreateScheduleVC(vm: vm)
            vc.modalPresentationStyle = .fullScreen
            
            // 일정 생성 완료 시, 화면 닫고 이벤트 외부로 전달
            vc.scheduleCreatedPublisher
                .sink { [weak vc] in
                    vc?.dismiss(animated: true)
                    promise(.success(()))
                }
                .store(in: &vc.cancellables)
            
            // 화면 전환
            self?.navigation.present(vc, animated: true)
        } }
        .eraseToAnyPublisher()
    }
    
    /// 전체 구성원 목록 화면으로 이동
    func pushMemberListVC() {
        let vm = HomeDI.shared.makeMemberListVM()
        let vc = MemberListVC(vm: vm)
        vc.hidesDefaultTabBarWhenPushed = true
        
        // 뒤로가기 탭하면 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &vc.cancellables)
        
        navigation.pushViewController(vc, animated: true)
    }
    
    /// 알림 목록 화면으로 이동
    func pushInboxVC() {
        let vc = InboxVC()
        vc.hidesDefaultTabBarWhenPushed = true
        
        // 뒤로가기 탭하면 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &vc.cancellables)
        
        navigation.pushViewController(vc, animated: true)
    }
}
