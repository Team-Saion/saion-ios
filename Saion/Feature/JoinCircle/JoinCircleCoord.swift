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

    private let circleJoinedSubject = PassthroughSubject<Void, Never>()

    var circleJoinedPublisher: AnyPublisher<Void, Never> {
        circleJoinedSubject.eraseToAnyPublisher()
    }

    // MARK: Start

    func start() {
        let vc = InputInvitationCodeVC()

        // 닫기 버튼 탭하면 참여 흐름 종료
        vc.closeBarButton.tapPublisher
            .sink { [weak self] in self?.close() }
            .store(in: &cancellables)

        // 입력한 초대 코드로 참여 확인 화면 이동
        vc.invitationCodeSubmitPublisher
            .sink { [weak self] in self?.pushJoinConfirmationVC(invitationCode: $0) }
            .store(in: &cancellables)

        navigation.pushViewController(vc, animated: false)
    }

    // MARK: Private Methods

    private func pushJoinConfirmationVC(invitationCode: String) {
        let vm = JoinCircleDI.shared.makeJoinConfirmationVM(invitationCode: invitationCode)
        let vc = JoinConfirmationVC(vm: vm)

        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)

        // 에러 알림 확인 후 참여 흐름 종료
        vc.errorAlertDismissedPublisher
            .sink { [weak self] in self?.close() }
            .store(in: &cancellables)

        vc.joinCircleCompletedPublisher
            .sink { [weak self] in
                self?.circleJoinedSubject.send(())
                self?.close()
            }
            .store(in: &cancellables)

        navigation.pushViewController(vc, animated: true)
    }

    private func close() {
        navigation.dismiss(animated: true) { [weak self] in self?.finish() }
    }
}
