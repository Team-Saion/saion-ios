//
//  InboxItem.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

/// 알림 보관함 항목
struct InboxItem: Hashable {
    /// 알림 식별자
    let id: Int
    /// 알림 유형
    let type: NotificationType
    /// 알림 제목
    let title: String
    /// 알림 본문
    let body: String
    /// 알림 발생 시각
    let occurredAt: Date
    /// 읽음 처리 시각
    let readAt: Date?
    /// 클릭 시 이동 정보
    let route: Route

    /// 알림 클릭 라우팅 정보
    struct Route: Hashable {
        /// 이동 화면 유형
        let type: RouteType
        /// 써클 식별자
        let circleID: String?
        /// 일정 식별자
        let scheduleID: String?
    }

    /// 알림 유형
    enum NotificationType: Hashable {
        case circleJoinCompleted
        case scheduleCreated
        case scheduleDeleted
        case scheduleReminderD7
        case scheduleReminderD1
        case scheduleReminderDDayAllDay
        case scheduleReminderDDayTimed
        case scheduleConfirmedByFamily
        case scheduleConfirmationRequested
    }

    /// 이동 화면 유형
    enum RouteType: Hashable {
        case circleHome
        case scheduleDetail
        case scheduleList
        case home
    }
}
