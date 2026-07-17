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
            .compactMap { [weak self] in self?.presentCreateScheduleVC(circleID: $0) }
            .switchToLatest()
            .sink { [weak vc] in vc?.overviewVC.refresh() }
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
    func presentCreateScheduleVC(circleID: String) -> AnyPublisher<Void, Never> {
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
}
