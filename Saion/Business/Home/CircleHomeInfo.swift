//
//  CircleHomeInfo.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

/// 서클 홈 정보
struct CircleHomeInfo {
    /// 서클 요약 정보
    let circle: CircleSummary
    /// 서클 구성원 목록
    let members: [MemberSummary]
    /// 초대 가능 여부
    let canInvite: Bool
    /// 대표 일정 정보
    let mainSchedule: ScheduleSummary?
    /// 일정 요약 목록
    let schedules: [ScheduleSummary]
    /// 전체 일정 개수
    let totalScheduleCount: Int
}
