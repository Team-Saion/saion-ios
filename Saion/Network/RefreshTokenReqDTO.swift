//
//  RefreshTokenReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

/// 인증 토큰 재발급 요청 DTO
struct RefreshTokenReqDTO: Encodable {
    /// 로그인 또는 직전 재발급에서 발급받은 refresh token
    let refreshToken: String
    
    init?(from refreshToken: String?) {
        guard let refreshToken else { return nil }
        self.refreshToken = refreshToken
    }
}
