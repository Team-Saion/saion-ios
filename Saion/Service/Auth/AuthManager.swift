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
    
    // MARK: Properties
    
    let store = AuthManagerStore()
    private var cancellables = Set<AnyCancellable>()
    
    var accessToken: String? { store.state.accessToken }
    var refreshToken: String? { store.state.refreshToken }
    
    // MARK: Singleton
    
    static let shared = AuthManager()
    private init() {}
    
    // MARK: Reactive Interface
    
    /// 현재 로그인 상태 퍼블리셔
    /// - Warning:
    ///   이 퍼블리셔를 API 호출 트리거로 직접 사용하면, 토큰 재발급 루프가 발생할 수 있음
    ///   API 호출 트리거로 사용하고자 한다면, `prefix(1)` 같은 안전장치를 두어 루프 발생을 예방해야 함
    var authStatePublisher: AnyPublisher<AuthState, Never> {
        store.$state
            .map(\.authState)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - AuthenticationCredential

extension AuthManager: AuthenticationCredential {
    var requiresRefresh: Bool { store.state.authState == .invalid }
}
