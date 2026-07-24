//
//  PushNotificationSettingsResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

/// 푸시 알림 설정 응답 DTO
struct PushNotificationSettingsResDTO: Decodable {
    /// D-7 알림 활성화 여부
    /// - example: true
    let d7Enabled: Bool
    /// D-1 알림 활성화 여부
    /// - example: true
    let d1Enabled: Bool
    /// D-day 알림 활성화 여부
    /// - example: true
    let dDayEnabled: Bool
    /// 가족 일정 확인 알림 활성화 여부
    /// - example: true
    let familyScheduleCheckEnabled: Bool
}

// MARK: - Mapper

extension PushNotificationSettingsResDTO {
    func toDomain() -> PushNotificationSettings {
        PushNotificationSettings(
            d7Enabled: d7Enabled,
            d1Enabled: d1Enabled,
            dDayEnabled: dDayEnabled,
            familyScheduleCheckEnabled: familyScheduleCheckEnabled
        )
    }
}
