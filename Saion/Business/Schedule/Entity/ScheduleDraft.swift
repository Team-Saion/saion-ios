//
//  ScheduleDraft.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Foundation

struct ScheduleDraft: Hashable {
    /// 일정 제목
    /// - 1~30자, 공백 전용 불가
    var title: String?
    /// 시작 일시
    var startAt: Date
    /// 시작 일시
    var endAt: Date
    /// 종일 일정 여부
    var isAllDay: Bool
    /// 확인하기 기능 활성 여부
    var needConfirm: Bool
    /// 메모
    /// - 최대 500자, 생략 가능
    var memo: String?
    
    init() {
        let calendar = Calendar.seoul
        /// 기본 시간(00:00~23:59)을 유지하면 DTO에서 종일 일정으로 처리한다. (``CreateScheduleReqDTO``참고)
        let startAt = calendar.startOfDay(for: .now)
        
        self.title = nil
        self.startAt = startAt
        self.endAt = calendar.date(
            byAdding: DateComponents(day: 1, minute: -1),
            to: startAt
        )!
        self.isAllDay = false
        self.needConfirm = false
        self.memo = nil
    }
}
