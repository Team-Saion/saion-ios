//
//  JoinConfirmationVM.swift
//  Saion
//
//  Created by 신정욱 on 7/25/26.
//

import Combine
import Foundation

import CasePaths

final class JoinConfirmationVM {

    // MARK: Types

    enum Action {
        /// 화면 진입 후 초대장 상세 조회 요청
        case viewDidLoad
        /// 참여 버튼 탭 후 초대 수락 요청
        case submitTapped
    }

    struct State {
        /// 조회한 초대장 상세 정보
        var invitationDetail: InvitationDetail?
        /// 초대한 사용자와 서클 이름으로 구성한 안내 문구
        var promptMessage: String? {
            guard let invitationDetail else { return nil }
            return "\(invitationDetail.inviter.nickname)님이 \(invitationDetail.circleName)에\n초대했어요"
        }

        /// 초대 수락 요청 진행 여부
        var isLoading: Bool = false
    }

    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 에러 알림 확인 후 현재 화면을 닫아야 하는 에러
        case presentErrorWithDismiss(LocalizedError)
        /// 서클 참여 완료
        case joinCircleCompleted
    }

    // MARK: Properties

    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()

    private let invitationCode: String

    private let invitationRepo: InvitationRepo

    // MARK: Initializer

    init(
        invitationCode: String,
        invitationRepo: InvitationRepo
    ) {
        self.invitationCode = invitationCode
        self.invitationRepo = invitationRepo
    }

    // MARK: Send

    func send(_ action: Action) {
        Task { @MainActor in
            do {
                try await process(action: action)
            } catch let error as LocalizedError {
                effect.send(.presentError(error))
            }
        }
    }

    // MARK: Process

    private func process(action: Action) async throws {
        switch action {
        case .viewDidLoad:
            do {
                state.invitationDetail =
                try await invitationRepo.fetchInvitationDetail(token: invitationCode)
            } catch let error as LocalizedError {
                effect.send(.presentErrorWithDismiss(error))
            }

        case .submitTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true

            _ = try await invitationRepo.acceptInvitation(token: invitationCode)
            effect.send(.joinCircleCompleted)
        }
    }
}
