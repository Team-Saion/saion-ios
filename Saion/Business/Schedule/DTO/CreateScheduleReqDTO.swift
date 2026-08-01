//
//  CreateScheduleReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Foundation

/// 일정 생성 요청 DTO
struct CreateScheduleReqDTO: Encodable {
    /// 일정 제목. 1~30자, 공백 전용 불가.
    /// - example: 제주도 여행
    let title: String
    /// 시작일 (yyyy-MM-dd)
    /// - example: 2024-08-01
    let startDate: String
    /// 종료일 (yyyy-MM-dd). startDate 이상이어야 합니다.
    /// - example: 2024-08-03
    let endDate: String
    /// 시작시간 (HH:mm). 생략하거나 null이면 종일 일정으로 저장됩니다.
    /// - example: 09:00
    let startTime: String?
    /// 종료시간 (HH:mm). startTime을 지정한 경우 필수입니다.
    /// - example: 18:00
    let endTime: String?
    /// 확인하기 기능 활성 여부
    /// - example: true
    let needConfirm: Bool
    /// 메모. 최대 500자, 생략 가능.
    /// - example: 숙소 체크인 15시
    let memo: String?
    
    // MARK: Mapper
    
    init?(from domain: ScheduleDraft) {
        guard let title = domain.title else { return nil }
        
        let formatter = DateFormatter.seoul
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: domain.startAt)
        let endDate = formatter.string(from: domain.endAt)
        
        formatter.dateFormat = "HH:mm"
        let startTime = formatter.string(from: domain.startAt)
        let endTime = formatter.string(from: domain.endAt)
        
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = domain.isAllDay ? nil : startTime
        self.endTime = domain.isAllDay ? nil : endTime
        self.needConfirm = domain.needConfirm
        self.memo = domain.memo
    }
}
