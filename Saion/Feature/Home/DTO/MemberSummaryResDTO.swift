//
//  MemberSummaryResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import Foundation

/// 서클 구성원 요약 응답 DTO
struct MemberSummaryResDTO: Decodable {
    /// 구성원 ID
    let memberId: String
    /// 닉네임
    let nickname: String
    /// 아바타 색상
    let avatarColor: AvatarColor
    /// 프로필 이미지 URL
    let profileImageUrl: String?
    /// 내 계정 여부
    let isMe: Bool
    /// 구성원 역할
    let role: String
    
    /// 멤버 아바타 기본 색상
    struct AvatarColor: Decodable {
        /// 아바타 색상 코드
        let code: String
        /// 아바타 색상 hex값
        let hex: String
    }
}

// MARK: Mapper

extension MemberSummaryResDTO {
    func toDomain() -> MemberSummary {
        MemberSummary(
            memberID: memberId,
            nickname: nickname,
            avatarColor: avatarColor.hex,
            isMe: isMe,
            role: role,
            profileImageURL: profileImageUrl.flatMap { URL(string: $0) }
        )
    }
}
