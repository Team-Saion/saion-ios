//
//  RegisterFCMTokenReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

/// FCM 푸시 토큰 등록 요청 DTO
struct RegisterFCMTokenReqDTO: Encodable {
    /// Firebase Installation ID
    /// - example: firebase-installation-id
    let installationId: String
    /// FCM 푸시 토큰
    /// - example: fcm-token
    let token: String
    /// 기기 플랫폼
    /// - example: IOS
    let platform: Platform

    /// 기기 플랫폼
    enum Platform: String, Encodable {
        case ios = "IOS"
        case android = "ANDROID"
    }
}
