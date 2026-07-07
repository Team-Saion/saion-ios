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
        case userDidLogin(accessToken: String, refreshToken: String)
        /// 사용자가 로그아웃함
        case userDidLogout
        /// 토큰이 재발급(리프레시)됨
        case tokensDidRefresh(accessToken: String, refreshToken: String)
    }
    
    struct State {
        /// 앱 설치 후 최초 실행 여부 (키체인 초기화 용도)
        @Storage("isFirstLaunch")
        fileprivate var isFirstLaunch: Bool = true
        /// 현재 인증 상태
        @SecureStorage("authState")
        var authState: AuthState = .signedOut
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
    
    @MainActor private func process(action: Action) async throws {
        switch action {
        case .appDidLaunch:
            // 앱을 재설치 한 경우, 키체인에 잔류하고 있는 토큰 초기화
            guard state.isFirstLaunch else { return }
            state.isFirstLaunch = false
            state.authState = .signedOut
            
        case .userDidLogin(let accessToken, let refreshToken),
                .tokensDidRefresh(let accessToken, let refreshToken):
            switch decodeRole(from: accessToken) {
            case .admin, .member:
                state.authState = .signedIn(
                    accessToken: accessToken,
                    refreshToken: refreshToken
                )
                
            default:
                state.authState = .onboarding(
                    accessToken: accessToken,
                    refreshToken: refreshToken
                )
            }
            
        case .userDidLogout:
            state.authState = .signedOut
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
