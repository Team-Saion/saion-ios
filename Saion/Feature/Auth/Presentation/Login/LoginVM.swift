//
//  LoginVM.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Combine
import UIKit

import CasePaths

final class LoginVM {
    
    // MARK: Types
    
    enum Action {
        /// 화면 표시됨
        case viewDidLoad
        /// 애플 로그인 버튼 탭
        case appleLoginTapped(window: UIWindow)
        /// 카카오 로그인 버튼 탭
        case kakaoLoginTapped
        /// 데모 모드 진입 요청됨
        case demoModeRequested
        /// 확인 버튼 탭
        case submitTapped
    }
    
    struct State {
        /// 로그인 및 온보딩 정보 조회 진행 여부
        var isLoading = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 약관 동의 시트 노출
        case presentTerms
        /// 기존 온보딩 정보와 함께 프로필 입력 화면으로 이동
        case pushProfileInput(OnboardingInfo)
    }
    
    // MARK: Properties
    
    /// 화면에 바인딩되는 현재 상태
    @Published private(set) var state = State()
    /// 화면 전환 및 에러 표시를 위한 일회성 이벤트
    let effect = PassthroughSubject<Effect, Never>()
    
    private let appleSignInClient = AppleSignInClient()
    
    private let kakaoAuthRepo: KakaoAuthRepo
    private let authRepo: AuthRepo
    private let memberRepo: MemberRepo
    
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
    
    /// 사용자 액션을 전달하고 처리 중 발생한 에러를 화면 이벤트로 변환
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
            // 소셜 인증만 완료된 사용자는 약관 동의부터 이어서 진행
            guard let tokenInfo = AuthManager.shared.state.authState.tokenInfo,
                  tokenInfo.role.is(\.pending)
            else { return }
            
            effect.send(.presentTerms)
            
        case .appleLoginTapped(let window):
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            let idToken = try await appleSignInClient.signIn(presenter: window)
            let tokenInfo = try await authRepo.requestLoginWithApple(idToken: idToken)
            AuthManager.shared.send(.userDidLogin(tokenInfo: tokenInfo))
            
            // 이미 정회원이면 바텀시트를 열지 않음
            if tokenInfo.role.is(\.pending) { effect.send(.presentTerms) }
            
        case .kakaoLoginTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            let idToken = try await kakaoAuthRepo.fetchKakaoIDToken()
            let tokenInfo = try await authRepo.requestLoginWithKakao(idToken: idToken)
            AuthManager.shared.send(.userDidLogin(tokenInfo: tokenInfo))
            
            // 이미 정회원이면 바텀시트를 열지 않음
            if tokenInfo.role.is(\.pending) { effect.send(.presentTerms) }
            
        case .demoModeRequested:
            guard let tokenInfo = TokenInfo(
                accessToken: Bundle.main.demoAccessToken,
                refreshToken: ""
            ) else { return }
            
            AuthManager.shared.send(.userDidLogin(tokenInfo: tokenInfo))
            
        case .submitTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            let onboardingInfo = try await memberRepo.fetchOnboardingInfo()
            effect.send(.pushProfileInput(onboardingInfo))
        }
    }
}
