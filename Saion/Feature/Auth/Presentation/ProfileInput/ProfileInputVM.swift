//
//  ProfileInputVM.swift
//  Saion
//
//  Created by 신정욱 on 7/2/26.
//

import Combine
import Foundation

import CasePaths

final class ProfileInputVM {
    
    // MARK: Types
    
    enum Action {
        /// 닉네임 텍스트 입력됨
        case textChanged(String?)
        /// 시작하기 버튼 탭
        case submitTapped
    }
    
    struct State {
        /// 프로필 뷰 상태
        let profileImageViewState: ProfileImageViewState
        /// 닉네임 플레이스 홀더
        let nicknamePlaceholder: String?
        /// 닉네임
        var nicknameText: String?
        
        /// 유효성 에러 (닉네임 데이터만 보고 판단)
        fileprivate var validationError: NicknameValidationError? {
            guard let nicknameText else { return nil }
            
            // 1순위: 10자 초과 → "10자 이내로 입력해주세요."
            if nicknameText.count > 10 { return .tooLong }
            
            // 2순위: 공백만 있음 → "닉네임을 입력해주세요."
            let trimmed = nicknameText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty { return .emptyOrWhitespace }
            
            // 3순위: 특수문자/이모지 포함됨 → "한글, 영문, 숫자만 사용할 수 있어요."
            let regex = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]*$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            if !predicate.evaluate(with: nicknameText) { return .containsSpecialChar }
            
            return nil
        }
        
        /// 하단 캡션 텍스트
        var captionText: String {
            // 에러가 있다면 에러 메시지 우선 노출, 아니면 기본 가이드 노출
            validationError?.errorDescription ?? "2~10자, 한글, 영문, 숫자만"
        }
        
        /// 유효성 에러 여부
        var hasValidationError: Bool { validationError != nil }
        
        /// 닉네임 유효 여부 (버튼 비활성화 목적)
        var isValidNickname: Bool {
            guard let nicknameText else { return false }
            // 2자 미만일 때는 유효하지 않음
            return nicknameText.count >= 2 && !hasValidationError
        }
        
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state: State
    let effect = PassthroughSubject<Effect, Never>()
    
    private let onboardingRepo: OnboardingRepo
    
    // MARK: Initializer
    
    init(
        onboardingInfo: OnboardingInfo,
        onboardingRepo: OnboardingRepo
    ) {
        self.state = .init(
            profileImageViewState: .init(from: onboardingInfo),
            nicknamePlaceholder: onboardingInfo.nickname ?? "닉네임",
            nicknameText: onboardingInfo.nickname
        )
        self.onboardingRepo = onboardingRepo
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
        case .textChanged(let text):
            state.nicknameText = text?.isEmpty == false ? text : nil
            
        case .submitTapped:
            guard !state.isLoading, let nicknameText = state.nicknameText else { return }
            
            state.isLoading = true
            defer { state.isLoading = false }
            
            let (accessToken, refreshToken) =
            try await onboardingRepo.completeOnboarding(nickname: nicknameText)
            
            AuthManager.shared.store.send(.userDidLogin(
                accessToken: accessToken,
                refreshToken: refreshToken
            ))
        }
    }
}
