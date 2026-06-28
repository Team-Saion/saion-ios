//
//  APISession.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import Alamofire

final class APISession {
    /// 인증이 필요한 요청용 세션
    /// - 토큰 인터셉터 + 공통 로깅 모니터 포함
    static let withAuth = Session(
        configuration: .default,
        interceptor: AuthenticationInterceptor(
            authenticator: TokenAuthenticator(),
            credential: AuthManager.shared
        ),
        eventMonitors: [APIEventMonitor()]
    )
    
    /// 인증이 필요 없는 일반 요청용 세션
    /// - 로깅만 적용된 기본 세션
    static let plain = Session(
        configuration: .default,
        eventMonitors: [APIEventMonitor()]
    )
}
