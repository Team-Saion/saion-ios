//
//  ScheduleCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import CombineCocoa

import Navigation

final class ScheduleCoord: Coordinator {
    
    // MARK: Start
    
    func start() {
        let vc = ScheduleListVC()
        
        // 일정 생성 화면으로 이동하고, 생성 완료 시 목록 갱신
        vc.createSchedulePublisher
            .compactMap { [weak self] in self?.presentCreateScheduleVC(circleID: $0) }
            .switchToLatest()
            .sink { [weak vc] in vc?.refresh() }
            .store(in: &cancellables)
        
        // 일정 상세 화면으로 이동하고, 삭제 완료 시 목록 갱신
        vc.scheduleDetailPublisher
            .compactMap { [weak self] in
                self?.pushScheduleDetailVC(circleID: $0.circleID, scheduleID: $0.scheduleID)
            }
            .switchToLatest()
            .sink { [weak vc] in vc?.refresh() }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
    
    /// 일정 생성 화면으로 이동
    private func presentCreateScheduleVC(circleID: String) -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let vm = ScheduleDI.shared.makeCreateScheduleVM(circleID: circleID)
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
    
    /// 일정 상세 화면으로 이동
    private func pushScheduleDetailVC(
        circleID: String,
        scheduleID: String
    ) -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let vm = ScheduleDI.shared.makeScheduleDetailVM(
                circleID: circleID,
                scheduleID: scheduleID
            )
            let vc = ScheduleDetailVC(vm: vm)
            vc.hidesDefaultTabBarWhenPushed = true
            
            // 일정 삭제 완료 시, 이전 화면으로 돌아가고 이벤트 외부로 전달
            vc.scheduleDeletedPublisher
                .sink { [weak self] in
                    self?.navigation.popViewController(animated: true)
                    promise(.success(()))
                }
                .store(in: &vc.cancellables)
            
            // 뒤로가기
            vc.backBarButton.tapPublisher
                .sink { [weak self] in self?.navigation.popViewController(animated: true) }
                .store(in: &vc.cancellables)
            
            // 화면 전환
            self?.navigation.pushViewController(vc, animated: true)
        } }
        .eraseToAnyPublisher()
    }
}
