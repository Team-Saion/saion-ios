//
//  IssueInvitationReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

/// 초대장 발급 요청 DTO
struct IssueInvitationReqDTO: Encodable {
    /// 초대 대상 ID (써클 ID)
    /// - example: CC20260101000000001
    let targetId: String
}
