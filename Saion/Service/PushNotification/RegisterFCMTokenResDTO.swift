//
//  RegisterFCMTokenResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

/// FCM 푸시 토큰 등록 응답 DTO
struct RegisterFCMTokenResDTO: Decodable {
    /// 푸시 토큰 식별자
    /// - example: 1
    let id: Int
    /// 기기 플랫폼
    /// - example: IOS
    let platform: Platform
    /// 활성 여부
    /// - example: true
    let active: Bool

    /// 기기 플랫폼
    enum Platform: String, Decodable {
        case ios = "IOS"
        case android = "ANDROID"
    }
}
