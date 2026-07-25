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
        let fractionalFormatter = ISO8601DateFormatter()
        fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let standardFormatter = ISO8601DateFormatter()
        standardFormatter.formatOptions = [.withInternetDateTime]

        let expiresAtWithTimeZone = expiresAt + "+09:00"
        guard let expiresAt = fractionalFormatter.date(from: expiresAtWithTimeZone)
                ?? standardFormatter.date(from: expiresAtWithTimeZone)
        else { return nil }

        return IssuedInvitation(
            invitationID: invitationId,
            token: token,
            expiresAt: expiresAt
        )
    }
}
