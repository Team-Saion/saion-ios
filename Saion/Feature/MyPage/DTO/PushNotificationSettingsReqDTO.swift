//
//  PushNotificationSettingsReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

/// 푸시 알림 설정 변경 요청 DTO
struct PushNotificationSettingsReqDTO: Encodable {
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
    
    // MARK: Mapper
    
    init(from domain: PushNotificationSettings) {
        self.d7Enabled = domain.d7Enabled
        self.d1Enabled = domain.d1Enabled
        self.dDayEnabled = domain.dDayEnabled
        self.familyScheduleCheckEnabled = domain.familyScheduleCheckEnabled
    }
}
