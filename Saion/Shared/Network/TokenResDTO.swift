//
//  TokenResDTO.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

/// 토큰 발급 응답 DTO
struct TokenResDTO: Decodable {
    /// 서비스 API 인증에 사용하는 access token
    let accessToken: String
    /// access token 재발급에 사용하는 refresh token
    let refreshToken: String
}
