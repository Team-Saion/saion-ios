//
//  InvitationDetailResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

/// 초대장 수락 화면 조회 응답 DTO
struct InvitationDetailResDTO: Decodable {
    /// 초대장 ID
    let invitationId: String
    /// 써클 이름
    let circleName: String
    /// 초대자 정보
    let inviter: Inviter
    /// 초대장 만료 일시
    let expiresAt: String

    /// 초대자 정보
    struct Inviter: Decodable {
        /// 닉네임
        let nickname: String
        /// 아바타 색상
        let avatarColor: String
    }
}

// MARK: - Mapper

extension InvitationDetailResDTO {
    func toDomain() -> InvitationDetail? {
        let fractionalFormatter = ISO8601DateFormatter()
        fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let standardFormatter = ISO8601DateFormatter()
        standardFormatter.formatOptions = [.withInternetDateTime]

        let expiresAtWithTimeZone = expiresAt + "+09:00"
        guard let expiresAt = fractionalFormatter.date(from: expiresAtWithTimeZone)
                ?? standardFormatter.date(from: expiresAtWithTimeZone)
        else { return nil }

        return InvitationDetail(
            invitationID: invitationId,
            circleName: circleName,
            inviter: InvitationDetail.Inviter(
                nickname: inviter.nickname,
                avatarColor: inviter.avatarColor
            ),
            expiresAt: expiresAt
        )
    }
}
