//
//  IssueInvitationResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

/// 초대장 발급 응답 DTO
struct IssueInvitationResDTO: Decodable {
    /// 초대장 ID
    let invitationId: String
    /// 초대 토큰
    let token: String
    /// 초대장 만료 일시
    let expiresAt: String
}

// MARK: - Mapper

extension IssueInvitationResDTO {
    func toDomain() -> IssuedInvitation? {
        let formatter = ISO8601DateFormatter.seoul
        guard let expiresAt = formatter.date(from: expiresAt) else { return nil }

        return IssuedInvitation(
            invitationID: invitationId,
            token: token,
            expiresAt: expiresAt
        )
    }
}
