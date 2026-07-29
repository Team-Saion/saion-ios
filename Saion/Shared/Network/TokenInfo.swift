//
//  TokenInfo.swift
//  Saion
//
//  Created by 신정욱 on 7/29/26.
//

import Foundation

import CasePaths

/// 인증 토큰과 access token의 `roles` 클레임에서 추출한 회원 권한 정보
struct TokenInfo: Equatable, Codable {
    
    /// 서비스에서 사용하는 회원 권한
    @CasePathable
    enum Role: String, Codable {
        /// 임시 회원 (온보딩 미완료)
        case pending = "PENDING"
        /// 정회원
        case member = "MEMBER"
        /// 관리자
        case admin = "ADMIN"
    }
    
    // MARK: Properties
    
    /// 서비스 API 인증에 사용하는 JWT
    let accessToken: String
    /// access token 재발급에 사용하는 토큰
    let refreshToken: String
    /// access token의 `roles` 클레임에서 추출한 회원 권한
    let role: TokenInfo.Role
    
    // MARK: Initializer
    
    /// access token에서 회원 권한을 추출해 토큰 정보를 생성
    /// - Returns: 권한을 추출할 수 없는 경우 `nil`
    init?(accessToken: String, refreshToken: String) {
        guard let role = TokenInfo.decodeRole(from: accessToken) else { return nil }
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.role = role
    }
    
    // MARK: Private Helper
    
    /// JWT 페이로드의 `roles` 배열에서 첫 번째 권한을 디코딩
    private static func decodeRole(from jwtToken: String) -> TokenInfo.Role? {
        let segments = jwtToken.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        // JWT 페이로드의 Base64URL 문자를 표준 Base64 문자로 치환
        var base64 = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // Base64 디코딩이 가능하도록 길이를 4의 배수로 보정
        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(String(repeating: "=", count: 4 - remainder))
        }
        
        // 페이로드를 JSON으로 변환하고 첫 번째 roles 값을 도메인 권한으로 매핑
        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let roleStr = (json["roles"] as? [String])?.first,
              let role = TokenInfo.Role(rawValue: roleStr)
        else { return nil }
        
        return role
    }
}
