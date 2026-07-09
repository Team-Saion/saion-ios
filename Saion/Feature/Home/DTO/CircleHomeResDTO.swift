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
    let mainSchedule: Schedule?
    /// 일정 요약 목록
    let schedules: [Schedule]
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
        let avatarColor: String
        /// 내 계정 여부
        let isMe: Bool
        /// 구성원 역할
        let role: String
    }
    
    /// 일정 요약 정보 (추후 필드 추가 예정)
    struct Schedule: Decodable {}
}
