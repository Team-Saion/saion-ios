//
//  InvitationDetail.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

/// 초대장 수락 화면 정보
struct InvitationDetail: Hashable {
    /// 초대장 ID
    let invitationID: String
    /// 써클 이름
    let circleName: String
    /// 초대자 정보
    let inviter: Inviter
    /// 초대장 만료 일시
    let expiresAt: Date

    /// 초대자 정보
    struct Inviter: Hashable {
        /// 닉네임
        let nickname: String
        /// 아바타 색상
        let avatarColor: String
    }
}
