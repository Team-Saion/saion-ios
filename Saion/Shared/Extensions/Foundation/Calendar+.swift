//
//  Calendar+.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Foundation

extension Calendar {
    /// 서울 기준 캘린더
    static let seoul = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.firstWeekday = 1 // 1 = Sunday
        return calendar
    }()
}
