//
//  JoinCircleCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Combine
import UIKit

import CombineCocoa

final class JoinCircleCoord: Coordinator {
    
    // MARK: Subjects
    
    /// 서클 참여 완료 서브젝트(출력)
    private let joinCircleCompletedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Start
    
    func start() {
        let vc = InputInvitationCodeVC()
        
        // 닫기 버튼 탭하면 참여 흐름 종료
        vc.closeBarButton.tapPublisher
            .sink { [weak self] in
                self?.navigation.dismiss(animated: true) { self?.removeFromParent() }
            }
            .store(in: &vc.cancellables)
        
        // 입력한 초대 코드로 참여 확인 화면 이동
        vc.invitationCodeSubmitPublisher
            .sink { [weak self] in self?.pushJoinConfirmationVC(invitationCode: $0) }
            .store(in: &vc.cancellables)
        
        navigation.pushViewController(vc, animated: false)
    }
    
    func startFromDeepLink(invitationCode: String) {
        start()
        pushJoinConfirmationVC(
            invitationCode: invitationCode,
            animated: false
        )
    }
    
    // MARK: Routing
    
    private func pushJoinConfirmationVC(
        invitationCode: String,
        animated: Bool = true
    ) {
        let vm = JoinCircleDI.shared.makeJoinConfirmationVM(invitationCode: invitationCode)
        let vc = JoinConfirmationVC(vm: vm)
        
        // 참여 완료 이벤트를 외부로 전달하고 참여 흐름 종료
        vc.joinCircleCompletedPublisher
            .sink { [weak self] in
                self?.joinCircleCompletedSubject.send(())
                self?.navigation.dismiss(animated: true) { self?.removeFromParent() }
            }
            .store(in: &vc.cancellables)
        
        navigation.pushViewController(vc, animated: animated)
    }
    
    // MARK: Reactive Interface
    
    /// 서클 참여 완료 퍼블리셔
    var joinCircleCompletedPublisher: AnyPublisher<Void, Never> {
        joinCircleCompletedSubject.eraseToAnyPublisher()
    }
}
