//
//  ScheduleCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import Navigation

final class ScheduleCoord: Coordinator {
    
    // MARK: Start
    
    func start(circleID: String) {
        let vm = ScheduleDI.shared.makeScheduleListVM(circleID: circleID)
        let vc = ScheduleListVC(vm: vm)
        
        // 일정 생성 화면으로 이동
        vc.createSchedulePublisher
            .sink { [weak self] in self?.presentCreateScheduleVC(circleID: circleID) }
            .store(in: &vc.cancellables)
        
        // 일정 상세 화면으로 이동
        vc.scheduleDetailPublisher
            .sink { [weak self] in
                self?.pushScheduleDetailVC(circleID: circleID, scheduleID: $0)
            }
            .store(in: &vc.cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }

    // MARK: Routing
    
    /// 일정 생성 화면으로 이동
    private func presentCreateScheduleVC(circleID: String) {
        let vm = ScheduleDI.shared.makeCreateScheduleVM(circleID: circleID)
        let vc = CreateScheduleVC(vm: vm)
        vc.modalPresentationStyle = .fullScreen
        
        // 화면 전환
        navigation.present(vc, animated: true)
    }
    
    /// 일정 상세 화면으로 이동
    private func pushScheduleDetailVC(
        circleID: String,
        scheduleID: String
    ) {
        let vm = ScheduleDI.shared.makeScheduleDetailVM(
            circleID: circleID,
            scheduleID: scheduleID
        )
        let vc = ScheduleDetailVC(vm: vm)
        vc.hidesDefaultTabBarWhenPushed = true
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
}
