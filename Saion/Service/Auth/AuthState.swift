//
//  AuthState.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Foundation

import CasePaths

@CasePathable
enum AuthState: Equatable, Codable {
    
    enum Role: String {
        /// 임시 회원 (온보딩 미완료)
        case pending = "PENDING"
        /// 정회원
        case member = "MEMBER"
        /// 관리자
        case admin = "ADMIN"
    }
    
    /// 로그인되지 않은 상태
    case signedOut
    /// 소셜 로그인 후 추가 정보 입력이 필요한 상태
    case onboarding(accessToken: String, refreshToken: String)
    /// 로그인 및 회원가입이 완료된 상태
    case signedIn(accessToken: String, refreshToken: String)
    
    var accessToken: String? {
        self[case: \.onboarding]?.accessToken
        ?? self[case: \.signedIn]?.accessToken
    }
    
    var refreshToken: String? {
        self[case: \.onboarding]?.refreshToken
        ?? self[case: \.signedIn]?.refreshToken
    }
}
