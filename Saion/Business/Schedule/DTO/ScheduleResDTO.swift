//
//  ScheduleResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/16/26.
//

import Foundation

/// 일정 상세 조회 응답 DTO
struct ScheduleResDTO: Decodable {
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
    /// 메모 (최대 500자). 등록된 메모가 없으면 null.
    /// - example: 숙소 체크인 15시
    let memo: String?
    /// 확인하기 종류별 카운트 목록. needConfirm=false이면 빈 배열([])을 반환합니다.
    let confirmations: [Confirmation]
    /// 내가 등록한 확인하기 정보. 등록한 확인하기가 없거나 needConfirm=false이면 null.
    let myConfirmation: MyConfirmation?
    /// 일정을 생성한 멤버 ID
    /// - example: 00000000-0000-0000-0000-000000000001
    let createdBy: String
    /// 생성 일시 (ISO 8601)
    /// - example: 2024-07-01T10:00:00
    let createdAt: String
    /// 오늘 기준 startDate까지 남은 일수. 진행 중이거나 시작일이 이미 지난 경우 null.
    let dDay: Int?
    
    /// 확인하기 종류별 카운트
    struct Confirmation: Decodable {
        /// 확인하기 종류
        /// - example: CONFIRMED
        let type: ConfirmationType
        /// 해당 종류를 선택한 멤버 수
        /// - example: 5
        let count: Int
    }
    
    /// 내 확인하기 정보
    struct MyConfirmation: Decodable {
        /// 확인하기 ID
        /// - example: 1
        let confirmationId: Int64
        /// 확인하기 종류
        /// - example: CONFIRMED
        let confirmationType: ConfirmationType
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
    
    /// 확인하기 종류
    enum ConfirmationType: String, Decodable {
        /// 확인했어요
        case confirmed = "CONFIRMED"
        /// 기타
        case etc = "ETC"
        
        func toDomain() -> Schedule.ConfirmationType {
            switch self {
            case .confirmed: .confirmed
            case .etc: .etc
            }
        }
    }
}

// MARK: - Mapper

extension ScheduleResDTO {
    func toDomain() -> Schedule? {
        let formatter = DateFormatter.seoul
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard
            let startAt = formatter.date(from: "\(startDate) \(startTime ?? "00:00")"),
            let endAt = formatter.date(from: "\(endDate) \(endTime ?? "23:59")")
        else { return nil }
        
        let isoFormatter = ISO8601DateFormatter.seoul
        guard let createdAt = isoFormatter.date(from: createdAt) else { return nil }
        let mappedStatus: ScheduleStatus = switch status {
        case .upcoming: .upcoming(dDay: dDay)
        case .inProgress: .inProgress
        case .completed: .completed
        }
        
        // 나의 확인 정보를 한 번만 변환해 반복 비교에 재사용합니다.
        let selectedConfirmation = myConfirmation.map {
            (type: $0.confirmationType.toDomain(), id: Int($0.confirmationId))
        }
        
        // 종류별 카운트를 Dictionary로 구성해 반복 탐색을 제거합니다.
        let confirmationCounts = confirmations.reduce(
            into: [Schedule.ConfirmationType: Int]()
        ) { counts, confirmation in
            counts[confirmation.type.toDomain()] = confirmation.count
        }
        
        // 서버 응답에 없는 종류도 count 0인 상태로 구성합니다.
        let mappedConfirmations = Schedule.ConfirmationType.allCases.map { confirmationType in
            let isSelected = selectedConfirmation?.type == confirmationType
            return Schedule.Confirmation(
                confirmationID: isSelected ? selectedConfirmation?.id : nil,
                type: confirmationType,
                count: confirmationCounts[confirmationType, default: 0],
                isSelected: isSelected
            )
        }
        
        return Schedule(
            scheduleID: scheduleId,
            title: title,
            startAt: startAt,
            endAt: endAt,
            isAllDay: isAllDay,
            needConfirm: needConfirm,
            status: mappedStatus,
            progressRate: progressRate,
            memo: memo,
            confirmations: mappedConfirmations,
            creatorID: createdBy,
            createdAt: createdAt,
            dDay: dDay
        )
    }
}
