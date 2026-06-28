//
//  KakaoLoginReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

/// 카카오 소셜 로그인 요청 DTO
struct KakaoLoginReqDTO: Encodable {
    /// 카카오에서 발급받은 ID Token
    let idToken: String
}
