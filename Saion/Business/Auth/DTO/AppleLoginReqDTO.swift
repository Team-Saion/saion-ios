//
//  AppleLoginReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 8/9/26.
//

import Foundation

/// 애플 소셜 로그인 요청 DTO
struct AppleLoginReqDTO: Encodable {
    /// 애플에서 발급받은 ID Token
    let idToken: String
}
