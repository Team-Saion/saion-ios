//
//  PushNotificationSettings.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

/// 푸시 알림 설정
struct PushNotificationSettings: Equatable {
    /// D-7 알림 활성화 여부
    var d7Enabled: Bool
    /// D-1 알림 활성화 여부
    var d1Enabled: Bool
    /// D-day 알림 활성화 여부
    var dDayEnabled: Bool
    /// 가족 일정 확인 알림 활성화 여부
    var familyScheduleCheckEnabled: Bool
}
