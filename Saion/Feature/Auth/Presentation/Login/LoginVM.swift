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
    private let loginRepo: LoginRepo
    private let onboardingRepo: OnboardingRepo
    
    // MARK: Initializer
    
    init(
        kakaoAuthRepo: KakaoAuthRepo,
        loginRepo: LoginRepo,
        onboardingRepo: OnboardingRepo
    ) {
        self.kakaoAuthRepo = kakaoAuthRepo
        self.loginRepo = loginRepo
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
        case .viewDidLoad:
            guard AuthManager.shared.store.state.authState.is(\.onboarding) else { return }
            effect.send(.presentTerms)
            
        case .kakaoLoginTapped:
            let idToken = try await kakaoAuthRepo.fetchKakaoIDToken()
            let (accessToken, refreshToken) =
            try await loginRepo.requestLoginWithKakao(idToken: idToken)
            
            AuthManager.shared.store.send(.userDidLogin(
                accessToken: accessToken,
                refreshToken: refreshToken
            ))
            
            effect.send(.presentTerms)
            
        case .submitTapped:
            guard !state.isLoading else { return }
            
            state.isLoading = true
            defer { state.isLoading = false }
            
            let onboardingInfo = try await onboardingRepo.fetchOnboardingInfo()
            effect.send(.pushProfileInput(onboardingInfo))
        }
    }
}

