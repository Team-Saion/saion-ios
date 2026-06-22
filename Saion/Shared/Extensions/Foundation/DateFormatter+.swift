//
//  DateFormatter+.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Foundation

extension DateFormatter {
    /// 서울 기준 날짜 포메터
    static var seoul: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = .seoul
        return formatter
    }
}
