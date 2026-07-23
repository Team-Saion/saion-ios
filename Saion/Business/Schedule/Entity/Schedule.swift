//
//  Schedule.swift
//  Saion
//
//  Created by 신정욱 on 7/16/26.
//

import Foundation

/// 일정 상세 정보
struct Schedule: Hashable {
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
    /// 메모
    let memo: String?
    /// 확인하기 목록
    var confirmations: [Confirmation]
    /// 일정 생성자 ID
    let creatorID: String
    /// 생성 일시
    let createdAt: Date
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
    
    /// 확인하기 종류별 카운트
    struct Confirmation: Hashable {
        /// 확인하기 ID
        let confirmationID: Int?
        /// 확인하기 종류
        let type: ConfirmationType
        /// 해당 종류를 선택한 멤버 수
        var count: Int
        /// 나의 선택 여부
        var isSelected: Bool
    }
    
    /// 확인하기 종류
    enum ConfirmationType: String, Hashable {
        /// 확인했어요
        case confirmed = "확인했어요"
        /// 기타
        case etc = "기타"
    }
}
