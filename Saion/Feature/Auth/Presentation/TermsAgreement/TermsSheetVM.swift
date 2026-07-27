//
//  TermsSheetVM.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

import Combine
import Foundation

import CasePaths

final class TermsSheetVM {
    
    // MARK: Types
    
    enum Action {
        /// 만 14세 이상 필수 동의 버튼 탭
        case ageConfirmationTapped
        /// 서비스 이용약관 필수 동의 버튼 탭
        case termsAgreementTapped
        /// 개인정보 수집 및 이용 필수 동의 버튼 탭
        case privacyAgreementTapped
        /// 제출 버튼 탭
        case submitTapped
    }
    
    struct State {
        /// 만 14세 이상 동의 여부
        var ageConfirmed = false
        /// 서비스 이용약관 동의 여부
        var termsAgreed = false
        /// 개인정보 수집 및 이용 동의 여부
        var privacyAgreed = false
        /// 전체 동의 완료 여부 (버튼 활성화 목적)
        var allAgreed: Bool { ageConfirmed && termsAgreed && privacyAgreed }
        
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 약관 동의 완료
        case termsAgreementCompleted
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    private let termRepo: TermRepo
    
    // MARK: Initializer
    
    init(termRepo: TermRepo) {
        self.termRepo = termRepo
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
        case .ageConfirmationTapped:
            state.ageConfirmed.toggle()
            
        case .termsAgreementTapped:
            state.termsAgreed.toggle()
            
        case .privacyAgreementTapped:
            state.privacyAgreed.toggle()
            
        case .submitTapped:
            guard !state.isLoading else { return }
            state.isLoading = true
            defer { state.isLoading = false }
            
            try await termRepo.agreeToTerms()
            effect.send(.termsAgreementCompleted)
        }
    }
}
