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
        /// 앱이 활성화 상태에 진입함
        case appDidBecomeActive
        /// 사용자가 로그인함
        case userDidLogin(accessToken: String, refreshToken: String)
        /// 사용자가 로그아웃함
        case userDidLogout
    }
    
    struct State {
        /// 앱 설치 후 최초 실행 여부 (키체인 초기화 용도)
        @Storage("isFirstLaunch")
        fileprivate var isFirstLaunch: Bool = true
        /// 액세스 토큰
        @SecureStorage("accessToken")
        fileprivate var accessToken: String?
        /// 리프레시 토큰
        @SecureStorage("refreshToken")
        fileprivate var refreshToken: String?
        /// 현재 인증 상태
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
            state.accessToken = nil
            state.refreshToken = nil

        case .appDidBecomeActive:
            // 토큰 유무 및 유효성 검사
            if validateTokenUC.execute(with: state.accessToken) {
                // 유효한 경우 인증 상태만 갱신
                state.authState = .valid
            } else {
                // 무효한 경우 상태를 변경하고 토큰을 삭제
                state.authState = .invalid
                state.accessToken = nil
                state.refreshToken = nil
            }
            
        case .userDidLogin(let accessToken, let refreshToken):
            state.authState = .valid
            state.accessToken = accessToken
            state.refreshToken = refreshToken

        case .userDidLogout:
            state.authState = .invalid
            state.accessToken = nil
            state.refreshToken = nil
        }
    }
}

