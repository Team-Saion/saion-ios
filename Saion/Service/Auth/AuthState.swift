//
//  AuthState.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Foundation

import CasePaths

/// 앱 전역에서 관리하는 사용자 인증 상태
@CasePathable
enum AuthState: Equatable, Codable {
    /// 인증 토큰이 없어 로그인되지 않은 상태
    case signedOut
    /// 소셜 인증이 완료되어 토큰이 발급된 상태
    /// `pending` 권한은 온보딩 미완료로 서비스를 이용할 수 없음
    case signedIn(tokenInfo: TokenInfo)
    
    /// 로그인 상태에 포함된 토큰 정보
    var tokenInfo: TokenInfo? { self[case: \.signedIn] }
}
