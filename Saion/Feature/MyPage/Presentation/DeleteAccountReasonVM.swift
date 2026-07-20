//
//  DeleteAccountReasonVM.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import Combine
import Foundation

import CasePaths

final class DeleteAccountReasonVM {
    
    // MARK: Types
    
    enum Action {
        /// 탈퇴 사유 입력값 변경됨
        case reasonChanged(String?)
        /// 탈퇴하기 버튼 탭
        case submitTapped
    }
    
    struct State {
        /// 앞뒤 공백을 제거한 탈퇴 사유
        var reason: String?
        /// 탈퇴 사유 입력에 따른 제출 버튼 활성화 여부
        var submitButtonEnabled: Bool { reason?.isEmpty == false }
        /// 네트워크 통신 여부
        var isLoading = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    private let memberRepo: MemberRepo
    
    // MARK: Initializer
    
    init(memberRepo: MemberRepo) {
        self.memberRepo = memberRepo
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
        case .reasonChanged(let string):
            let trimmed = string?.trimmingCharacters(in: .whitespacesAndNewlines)
            state.reason = trimmed?.isEmpty == true ? nil : trimmed
            
        case .submitTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            // 탈퇴 버튼 활성화 조건에 따라 reason 값이 있음을 보장
            try await memberRepo.deleteAccount(reason: state.reason!)
            AuthManager.shared.store.send(.userDidLogout)
        }
    }
}
