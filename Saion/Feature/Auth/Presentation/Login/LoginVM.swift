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
            
            // 이미 정회원이면 바텀시트를 열지 않음
            if decodeRole(from: accessToken) != .member {
                effect.send(.presentTerms)
            }
            
        case .submitTapped:
            guard !state.isLoading else { return }
            
            state.isLoading = true
            defer { state.isLoading = false }
            
            let onboardingInfo = try await onboardingRepo.fetchOnboardingInfo()
            effect.send(.pushProfileInput(onboardingInfo))
        }
    }
    
    // MARK: Private Helper
    
    /// JWT 페이로드에서 role 값을 디코딩하여 반환
    private func decodeRole(from jwtToken: String) -> AuthState.Role? {
        let segments = jwtToken.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        // Base64url 포맷을 Base64 표준 포맷으로 변환해
        var base64 = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // 4의 배수가 되도록 패딩(=)을 추가해
        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(String(repeating: "=", count: 4 - remainder))
        }
        
        // Data를 JSON 객체로 변환하여 roles 배열의 첫 번째 요소를 추출
        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let roleStr = (json["roles"] as? [String])?.first,
              let role = AuthState.Role(rawValue: roleStr)
        else { return nil }
        
        return role
    }
}

