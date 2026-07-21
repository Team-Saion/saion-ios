//
//  CreateScheduleResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Foundation

/// 일정 생성 응답 DTO
struct CreateScheduleResDTO: Decodable {
    /// 생성된 일정 ID
    /// - example: SC202407070000000001
    let scheduleId: String
}
