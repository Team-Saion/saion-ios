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
}
