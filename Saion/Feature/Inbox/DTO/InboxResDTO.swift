//
//  InboxResDTO.swift
//  Saion
//  살려줘 너무 피곤하다. 진짜
//  Created by 신정욱 on 7/24/26.
//

import Foundation

/// 알림 보관함 조회 응답 DTO
struct InboxResDTO: Decodable {
    /// 알림 목록
    let items: [Item]
    /// 다음 페이지 커서
    /// - example: 10
    let nextCursor: Int64?
    
    /// 알림 보관함 항목 응답
    struct Item: Decodable {
        /// 알림 식별자
        /// - example: 1
        let id: Int64
        /// 알림 유형
        /// - example: SCHEDULE_CREATED
        let type: NotificationType
        /// 알림 제목
        /// - example: 새 일정이 등록됐어요
        let title: String
        /// 알림 본문
        /// - example: 민수님이 '병원 방문' 일정을 추가했어요.
        let body: String
        /// 알림 발생 시각
        let occurredAt: String
        /// 읽음 처리 시각. MVP 화면에서는 읽음 여부를 별도 노출하지 않는다.
        let readAt: String?
        /// 클릭 시 이동 정보
        let route: Route
    }
    
    /// 알림 클릭 라우팅 응답
    struct Route: Decodable {
        /// 이동 화면 유형
        /// - example: SCHEDULE_DETAIL
        let type: RouteType
        /// 써클 식별자
        /// - example: circle-id
        let circleId: String?
        /// 일정 식별자
        /// - example: schedule-id
        let scheduleId: String?
    }
    
    /// 알림 유형
    enum NotificationType: String, Decodable {
        case circleJoinCompleted = "CIRCLE_JOIN_COMPLETED"
        case scheduleCreated = "SCHEDULE_CREATED"
        case scheduleDeleted = "SCHEDULE_DELETED"
        case scheduleReminderD7 = "SCHEDULE_REMINDER_D7"
        case scheduleReminderD1 = "SCHEDULE_REMINDER_D1"
        case scheduleReminderDDayAllDay = "SCHEDULE_REMINDER_DDAY_ALL_DAY"
        case scheduleReminderDDayTimed = "SCHEDULE_REMINDER_DDAY_TIMED"
        case scheduleConfirmedByFamily = "SCHEDULE_CONFIRMED_BY_FAMILY"
        case scheduleConfirmationRequested = "SCHEDULE_CONFIRMATION_REQUESTED"
        case scheduleFamilyNotificationRequested = "SCHEDULE_FAMILY_NOTIFICATION_REQUESTED"
    }
    
    /// 이동 화면 유형
    enum RouteType: String, Decodable {
        case circleHome = "CIRCLE_HOME"
        case scheduleDetail = "SCHEDULE_DETAIL"
        case scheduleList = "SCHEDULE_LIST"
        case home = "HOME"
    }
}

// MARK: - Mapper

extension InboxResDTO {
    func toDomain() -> Pagenation<InboxItem>? {
        let fractionalFormatter = ISO8601DateFormatter()
        fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let standardFormatter = ISO8601DateFormatter()
        standardFormatter.formatOptions = [.withInternetDateTime]
        
        let timeZoneOffset = "+09:00"
        var mappedItems = [InboxItem]()
        for item in items {
            let occurredAtValue = item.occurredAt + timeZoneOffset
            guard let occurredAt = fractionalFormatter.date(from: occurredAtValue)
                    ?? standardFormatter.date(from: occurredAtValue)
            else { return nil }
            
            let readAt: Date?
            if let readAtValue = item.readAt {
                let offsetReadAtValue = readAtValue + timeZoneOffset
                guard let parsedReadAt = fractionalFormatter.date(from: offsetReadAtValue)
                        ?? standardFormatter.date(from: offsetReadAtValue)
                else { return nil }
                readAt = parsedReadAt
            } else {
                readAt = nil
            }
            
            let type: InboxItem.NotificationType
            switch item.type {
            case .circleJoinCompleted: type = .circleJoinCompleted
            case .scheduleCreated: type = .scheduleCreated
            case .scheduleDeleted: type = .scheduleDeleted
            case .scheduleReminderD7: type = .scheduleReminderD7
            case .scheduleReminderD1: type = .scheduleReminderD1
            case .scheduleReminderDDayAllDay: type = .scheduleReminderDDayAllDay
            case .scheduleReminderDDayTimed: type = .scheduleReminderDDayTimed
            case .scheduleConfirmedByFamily: type = .scheduleConfirmedByFamily
            case .scheduleConfirmationRequested: type = .scheduleConfirmationRequested
            case .scheduleFamilyNotificationRequested: type = .scheduleFamilyNotificationRequested
            }
            
            let routeType: InboxItem.RouteType
            switch item.route.type {
            case .circleHome: routeType = .circleHome
            case .scheduleDetail: routeType = .scheduleDetail
            case .scheduleList: routeType = .scheduleList
            case .home: routeType = .home
            }
            
            mappedItems.append(InboxItem(
                id: Int(item.id),
                type: type,
                title: item.title,
                body: item.body,
                occurredAt: occurredAt,
                readAt: readAt,
                route: InboxItem.Route(
                    type: routeType,
                    circleID: item.route.circleId,
                    scheduleID: item.route.scheduleId
                )
            ))
        }
        
        return Pagenation(
            elemets: mappedItems,
            nextCursor: nextCursor.map(String.init),
            hasNext: nextCursor != nil
        )
    }
}
