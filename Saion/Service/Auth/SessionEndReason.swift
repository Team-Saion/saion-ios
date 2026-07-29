//
//  SessionEndReason.swift
//  Saion
//
//  Created by 신정욱 on 7/29/26.
//

enum SessionEndReason {
    /// 사용자가 직접 로그아웃함
    case userInitiated
    /// 인증 토큰이 만료됨
    case tokenExpired
    /// 사용자 정보를 정상적으로 가져올 수 없음
    case memberInfoUnavailable
}
