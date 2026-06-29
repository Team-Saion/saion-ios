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
        /// 카카오 로그인 버튼 탭
        case kakaoLoginTapped
    }
    
    struct State {}
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    private let effect = PassthroughSubject<Effect, Never>()
    var effectPublisher: AnyPublisher<Effect, Never> { effect.eraseToAnyPublisher() }
    
    private let kakaoAuthRepo: KakaoAuthRepo
    private let loginRepo: LoginRepo
    
    // MARK: Initializer
    
    init(
        kakaoAuthRepo: KakaoAuthRepo,
        loginRepo: LoginRepo
    ) {
        self.kakaoAuthRepo = kakaoAuthRepo
        self.loginRepo = loginRepo
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
        case .kakaoLoginTapped:
            let idToken = try await kakaoAuthRepo.fetchKakaoIDToken()
            let (accessToken, refreshToken, role) =
            try await loginRepo.requestLoginWithKakao(idToken: idToken)
            
            AuthManager.shared.store.send(.userDidLogin(
                accessToken: accessToken,
                refreshToken: refreshToken,
                role: role
            ))
        }
    }
}

