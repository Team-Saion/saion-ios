//
//  CircleHomeResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import Foundation

/// 서클 홈 조회 응답 DTO
struct CircleHomeResDTO: Decodable {
    /// 서클 요약 정보
    let circle: Circle
    /// 서클 구성원 목록
    let members: [MemberSummaryResDTO]
    /// 초대 가능 여부
    let canInvite: Bool
    /// 대표 일정 정보
    let mainSchedule: ScheduleSummaryResDTO?
    /// 일정 요약 목록
    let schedules: [ScheduleSummaryResDTO]
    /// 전체 일정 개수
    let totalScheduleCount: Int
    
    /// 서클 요약 정보
    struct Circle: Decodable {
        /// 서클 ID
        let circleId: String
        /// 서클 이름
        let name: String
        /// 서클 소유자 ID
        let ownerId: String
    }
}

// MARK: Mapper

extension CircleHomeResDTO {
    func toDomain() -> CircleHomeInfo? {
        let mainSchedule: ScheduleSummary?
        if let mainScheduleDTO = self.mainSchedule {
            guard let mappedSchedule = mainScheduleDTO.toDomain() else { return nil }
            mainSchedule = mappedSchedule
        } else {
            mainSchedule = nil
        }
        
        let schedules = self.schedules.compactMap { $0.toDomain() }
        guard schedules.count == self.schedules.count else { return nil }
        
        return CircleHomeInfo(
            circle: CircleSummary(
                circleID: circle.circleId,
                name: circle.name,
                ownerID: circle.ownerId
            ),
            members: members.map { $0.toDomain() },
            canInvite: canInvite,
            mainSchedule: mainSchedule,
            schedules: schedules,
            totalScheduleCount: totalScheduleCount
        )
    }
}
