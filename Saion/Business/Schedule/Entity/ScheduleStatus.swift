//
//  ScheduleStatus.swift
//  Saion
//
//  Created by 신정욱 on 8/1/26.
//

/// 일정 상태
enum ScheduleStatus: Hashable {
    /// 시작 전
    case upcoming(dDay: Int?)
    /// 진행 중
    case inProgress
    /// 완료
    case completed
}
