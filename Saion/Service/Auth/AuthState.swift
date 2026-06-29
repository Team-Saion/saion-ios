//
//  AuthState.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Foundation

enum AuthState: Equatable, Codable {
    
    enum Role: String, Codable {
        /// 임시 회원 (온보딩 미완료)
        case pending = "PENDING"
        /// 정회원
        case member = "MEMBER"
        /// 관리자
        case admin = "ADMIN"
    }
    
    /// 인증 상태 검증 전
    case unknown
    /// 유효
    case valid(
        accessToken: String,
        refreshToken: String,
        role: Role
    )
    /// 무효
    case invalid
}
