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
        case userDidLogin(tokenInfo: TokenInfo)
        /// 토큰이 재발급(리프레시)됨
        case tokensDidRefresh(tokenInfo: TokenInfo)
        /// 사용자가 로그아웃함
        case userDidLogout(reason: SessionEndReason)
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
        /// 로그아웃 사유 노출
        case presentLogoutReason(LocalizedError)
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = CurrentValueSubject<Effect?, Never>(nil)
    
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
            state.authState = .signedOut
            
        case .userDidLogin(let tokenInfo), .tokensDidRefresh(let tokenInfo):
            state.authState = .signedIn(tokenInfo: tokenInfo)
            
        case .userDidLogout(let reason):
            switch reason {
            case .userInitiated:
                effect.send(.presentLogoutReason(SaionError(
                    userMessage: "정상적으로 로그인됐지만 테스트에요.",
                    errorCode: "AMS-FL-2"
                )))
                
            case .tokenExpired:
                effect.send(.presentLogoutReason(SaionError(
                    userMessage: "로그인이 만료됐어요. 다시 로그인해 주세요.",
                    errorCode: "AMS-FL-0"
                )))
                
            case .memberInfoUnavailable:
                effect.send(.presentLogoutReason(SaionError(
                    userMessage: "회원 정보를 불러올 수 없어 로그아웃했어요.",
                    errorCode: "AMS-FL-1"
                )))
            }
            state.authState = .signedOut
        }
    }
}
