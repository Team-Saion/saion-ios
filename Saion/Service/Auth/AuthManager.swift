//
//  AuthManager.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Combine
import Foundation

import Alamofire

final class AuthManager {
    
    // MARK: Types
    
    enum Action {
        /// 앱이 실행됨
        case appDidLaunch
        /// 사용자가 로그인함
        case userDidLogin(tokenInfo: TokenInfo)
        /// 토큰이 재발급(리프레시)됨
        case tokensDidRefresh(tokenInfo: TokenInfo)
        /// 사용자가 로그아웃함
        case userDidLogout
    }
    
    struct State {
        /// 앱 설치 후 최초 실행 여부 (키체인 초기화 용도)
        @Storage("isFirstLaunch")
        fileprivate var isFirstLaunch: Bool = true
        /// 현재 인증 상태
        @SecureStorage("authState")
        var authState: AuthState = .signedOut
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    
    private let validateTokenUC = ValidateTokenUC()
    
    // MARK: Singleton
    
    static let shared = AuthManager()
    private init() {}
    
    // MARK: Send
    
    func send(_ action: Action) {
        switch action {
        case .appDidLaunch:
            // 앱을 재설치 한 경우, 키체인에 잔류하고 있는 토큰 초기화
            guard state.isFirstLaunch else { return }
            state.isFirstLaunch = false
            state.authState = .signedOut
            
        case .userDidLogin(let tokenInfo), .tokensDidRefresh(let tokenInfo):
            state.authState = .signedIn(tokenInfo: tokenInfo)
            
        case .userDidLogout:
            state.authState = .signedOut
        }
    }
}

// MARK: - Public Interface

extension AuthManager {
    var accessToken: String? { state.authState.tokenInfo?.accessToken }
    var refreshToken: String? { state.authState.tokenInfo?.refreshToken }
    
    /// 현재 인증 상태 퍼블리셔
    var authStatePublisher: AnyPublisher<AuthState, Never> {
        $state
            .map(\.authState)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - AuthenticationCredential

extension AuthManager: AuthenticationCredential {
    /// 인증 토큰 선제 갱신 여부
    /// 서버가 만료된 access token에 대해 항상 정확하게 401을 반환한다면 requiresRefresh는 필수는 아님.
    var requiresRefresh: Bool { false }
}
