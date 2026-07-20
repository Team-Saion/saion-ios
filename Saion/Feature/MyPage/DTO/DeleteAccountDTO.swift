//
//  DeleteAccountDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import Foundation

/// 회원 탈퇴 요청 DTO
struct DeleteAccountDTO: Encodable {
    /// 탈퇴 사유. 최대 500자.
    let reason: String
}
