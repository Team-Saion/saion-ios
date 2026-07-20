//
//  ScheduleSummary.swift
//  Saion
//
//  Created by 신정욱 on 7/16/26.
//

import Foundation

/// 일정 요약
struct ScheduleSummary: Hashable {
    /// 일정 ID
    let scheduleID: String
    /// 일정 제목
    let title: String
    /// 시작 일시
    let startAt: Date
    /// 종료 일시
    let endAt: Date
    /// 종일 일정 여부
    let isAllDay: Bool
    /// 확인하기 기능 활성 여부
    let needConfirm: Bool
    /// 일정 상태
    let status: Status
    /// 진행률 (0~100)
    let progressRate: Int
    /// 시작일까지 남은 일수
    let dDay: Int?
    
    /// 일정 상태
    enum Status: Hashable {
        /// 시작 전
        case upcoming
        /// 진행 중
        case inProgress
        /// 완료
        case completed
    }
}
