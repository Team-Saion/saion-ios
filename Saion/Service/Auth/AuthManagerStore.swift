//
//  AuthManagerStore.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Combine
import Foundation

import CasePaths

final class AuthManagerStore {
    
    // MARK: Types
    
    enum Action {
        /// 앱이 실행됨
        case appDidLaunch
        /// 사용자가 로그인함
        case userDidLogin(
            accessToken: String,
            refreshToken: String,
            role: AuthState.Role
        )
        /// 사용자가 로그아웃함
        case userDidLogout
        /// 토큰이 재발급(리프레시)됨
        case tokensDidRefresh(
            accessToken: String,
            refreshToken: String
        )
    }
    
    struct State {
        /// 앱 설치 후 최초 실행 여부 (키체인 초기화 용도)
        @Storage("isFirstLaunch")
        fileprivate var isFirstLaunch: Bool = true
        /// 현재 인증 상태
        @SecureStorage("authState")
        var authState: AuthState = .unknown
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    private let effect = PassthroughSubject<Effect, Never>()
    
    private let validateTokenUC = ValidateTokenUC()
    
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
        case .appDidLaunch:
            // 앱을 재설치 한 경우, 키체인에 잔류하고 있는 토큰 초기화
            guard state.isFirstLaunch else { return }
            state.isFirstLaunch = false
            state.authState = .invalid
            
        case .userDidLogin(let accessToken, let refreshToken, let role):
            state.authState = .valid(
                accessToken: accessToken,
                refreshToken: refreshToken,
                role: role
            )
            
        case .userDidLogout:
            state.authState = .invalid
            
        case .tokensDidRefresh(let accessToken, let refreshToken):
            // 토큰만 갱신하고, 기존 사용자 권한은 유지
            if case let .valid(_, _, role) = state.authState {
                state.authState = .valid(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    role: role
                )
                
            } else {
                state.authState = .invalid
            }
        }
    }
}

