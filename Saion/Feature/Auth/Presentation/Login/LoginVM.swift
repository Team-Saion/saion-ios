//
//  LoginVM.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Combine
import Foundation

import CasePaths

final class LoginVM {
    
    // MARK: Types
    
    enum Action {
        /// 화면 표시됨
        case viewDidLoad
        /// 카카오 로그인 버튼 탭
        case kakaoLoginTapped
        /// 확인 버튼 탭
        case submitTapped
    }
    
    struct State {
        var isLoading = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        case presentTerms
        case pushProfileInput(OnboardingInfo)
    }
    
    // MARK: Properties
    
    
    @Published private(set) var state = State()
    private let effect = PassthroughSubject<Effect, Never>()
    var effectPublisher: AnyPublisher<Effect, Never> { effect.eraseToAnyPublisher() }
    private var cancellables = Set<AnyCancellable>()
    
    private let kakaoAuthRepo: KakaoAuthRepo
    private let authRepo: AuthRepo
    private let memberRepo: MemberRepo
    
    private let authStore = AuthManager.shared.store
    
    // MARK: Initializer
    
    init(
        kakaoAuthRepo: KakaoAuthRepo,
        authRepo: AuthRepo,
        memberRepo: MemberRepo
    ) {
        self.kakaoAuthRepo = kakaoAuthRepo
        self.authRepo = authRepo
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
        case .viewDidLoad:
            // 강제 로그아웃 사유가 있으면 저장된 값을 제거한 뒤 에러로 전달
            if let logoutReason = authStore.effect.value?[case: \.presentLogoutReason] {
                authStore.effect.value = nil
                throw logoutReason
                
            } else if let tokenInfo = authStore.state.authState.tokenInfo,
                      tokenInfo.role.is(\.pending) {
                // 소셜 인증만 완료된 사용자는 약관 동의부터 이어서 진행
                effect.send(.presentTerms)
            }
            
        case .kakaoLoginTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true

            let idToken = try await kakaoAuthRepo.fetchKakaoIDToken()
            let tokenInfo = try await authRepo.requestLoginWithKakao(idToken: idToken)
            authStore.send(.userDidLogin(tokenInfo: tokenInfo))
            // 이미 정회원이면 바텀시트를 열지 않음
            if tokenInfo.role.is(\.pending) { effect.send(.presentTerms) }
            
        case .submitTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            let onboardingInfo = try await memberRepo.fetchOnboardingInfo()
            effect.send(.pushProfileInput(onboardingInfo))
        }
    }
}
