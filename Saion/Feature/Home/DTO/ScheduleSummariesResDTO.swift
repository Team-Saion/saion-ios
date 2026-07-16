//
//  ScheduleSummariesResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/16/26.
//

import Foundation

/// 일정 목록 조회 응답 DTO
struct ScheduleSummariesResDTO: Decodable {
    /// 일정 요약 목록. startDate ASC → startTime ASC → scheduleId ASC 순서로 정렬됩니다.
    let schedules: [Schedule]
    /// 다음 페이지 커서. 다음 요청의 cursor 파라미터로 전달합니다. hasNext=false이면 null.
    let nextCursor: String?
    /// 다음 페이지 존재 여부. false이면 마지막 페이지입니다.
    /// - example: true
    let hasNext: Bool
    
    /// 일정 요약 정보
    struct Schedule: Decodable {
        /// 일정 ID
        /// - example: SC202407070000000001
        let scheduleId: String
        /// 일정 제목
        /// - example: 제주도 여행
        let title: String
        /// 시작일 (yyyy-MM-dd)
        /// - example: 2024-08-01
        let startDate: String
        /// 종료일 (yyyy-MM-dd)
        /// - example: 2024-08-03
        let endDate: String
        /// 시작시간 (HH:mm). isAllDay=true이면 null.
        /// - example: 09:00
        let startTime: String?
        /// 종료시간 (HH:mm). isAllDay=true이면 null.
        /// - example: 18:00
        let endTime: String?
        /// 종일 일정 여부. startTime/endTime이 모두 null이면 true.
        /// - example: false
        let isAllDay: Bool
        /// 확인하기 기능 활성 여부
        /// - example: true
        let needConfirm: Bool
        /// 일정 상태. KST 현재 시각 기준으로 계산됩니다.
        /// - example: UPCOMING
        let status: Status
        /// 진행률 (0~100 정수). KST 현재 시각 기준으로 계산됩니다.
        /// - example: 0
        let progressRate: Int
        /// startDate와 오늘(KST) 간의 양수 차이. 진행 중이거나 과거 일정은 null.
        let dday: Int?
    }
    
    /// 일정 상태
    enum Status: String, Decodable {
        /// 시작일시 이전
        case upcoming = "UPCOMING"
        /// 시작일시 이상, 종료일시 이하
        case inProgress = "IN_PROGRESS"
        /// 종료일시 초과
        case completed = "COMPLETED"
    }
}

// MARK: - Mapper

extension ScheduleSummariesResDTO.Schedule {
    func toDomain() -> ScheduleSummary? {
        let formatter = DateFormatter.seoul
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard
            let startAt = formatter.date(from: "\(startDate) \(startTime ?? "00:00")"),
            let endAt = formatter.date(from: "\(endDate) \(endTime ?? "23:59")")
        else { return nil }

        return ScheduleSummary(
            scheduleID: scheduleId,
            title: title,
            startAt: startAt,
            endAt: endAt,
            isAllDay: isAllDay,
            needConfirm: needConfirm,
            status: status.toDomain(),
            progressRate: progressRate,
            dDay: dday
        )
    }
}

private extension ScheduleSummariesResDTO.Status {
    func toDomain() -> ScheduleSummary.Status {
        switch self {
        case .upcoming: .upcoming
        case .inProgress: .inProgress
        case .completed: .completed
        }
    }
}
