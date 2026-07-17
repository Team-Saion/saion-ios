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
    let members: [Member]
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
    
    /// 서클 구성원 정보
    struct Member: Decodable {
        /// 구성원 ID
        let memberId: String
        /// 닉네임
        let nickname: String
        /// 아바타 색상
        let avatarColor: AvatarColor
        /// 프로필 이미지 URL
        let profileImageUrl: String?
        /// 내 계정 여부
        let me: Bool
        /// 구성원 역할
        let role: String
    }
    
    /// 멤버 아바타 기본 색상
    struct AvatarColor: Decodable {
        /// 아바타 색상 코드
        let code: String
        /// 아바타 색상 hex값
        let hex: String
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
            members: members.map {
                MemberSummary(
                    memberID: $0.memberId,
                    nickname: $0.nickname,
                    avatarColor: $0.avatarColor.hex,
                    isMe: $0.me,
                    role: $0.role,
                    profileImageURL: $0.profileImageUrl.flatMap { URL(string: $0) }
                )
            },
            canInvite: canInvite,
            mainSchedule: mainSchedule,
            schedules: schedules,
            totalScheduleCount: totalScheduleCount
        )
    }
}
