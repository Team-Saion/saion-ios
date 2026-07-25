//
//  IssuedInvitation.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

/// 발급된 초대장
struct IssuedInvitation: Hashable {
    /// 초대장 ID
    let invitationID: String
    /// 초대 토큰
    let token: String
    /// 초대장 만료 일시
    let expiresAt: Date
}
