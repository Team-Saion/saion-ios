//
//  ISO8601DateFormatter+.swift
//  Saion
//
//  Created by 신정욱 on 7/27/26.
//

import Foundation

extension ISO8601DateFormatter {
    /// 서울 기준 날짜 포메터
    static var seoul: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.formatOptions = [
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withFractionalSeconds
        ]
        return formatter
    }
}
