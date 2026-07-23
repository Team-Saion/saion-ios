//
//  RegisterConfirmationReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

/// 확인하기 등록/변경 요청 DTO
struct RegisterConfirmationReqDTO: Encodable {
    /// 확인하기 종류
    /// - example: CONFIRMED
    let confirmationType: ConfirmationType

    /// 확인하기 종류
    enum ConfirmationType: String, Encodable {
        /// 확인했어요
        case confirmed = "CONFIRMED"
        /// 기타
        case etc = "ETC"
    }
}
