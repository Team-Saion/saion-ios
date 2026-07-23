//
//  RegisterConfirmationResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

/// 확인하기 등록/변경 응답 DTO
struct RegisterConfirmationResDTO: Decodable {
    /// 최종 반영된 확인하기 종류
    /// - example: CONFIRMED
    let confirmationType: ConfirmationType

    /// 확인하기 종류
    enum ConfirmationType: String, Decodable {
        /// 확인했어요
        case confirmed = "CONFIRMED"
        /// 기타
        case etc = "ETC"
    }
}
