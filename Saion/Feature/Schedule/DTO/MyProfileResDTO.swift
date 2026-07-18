//
//  MyProfileResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/18/26.
//

import Foundation

/// 내 프로필 조회 응답 DTO
struct MyProfileResDTO: Decodable {
    /// 멤버 ID
    /// - example: 00000000-0000-0000-0000-000000000001
    let id: String
    /// 이메일
    /// - example: user@example.com
    let email: String?
    /// 이름
    /// - example: 홍길동
    let name: String?
    /// 닉네임
    /// - example: 길동이
    let nickname: String
    /// 멤버 역할
    /// - example: MEMBER
    let role: Role
    /// 멤버 아바타 기본 색상
    let avatarColor: AvatarColor
    /// 프로필 이미지 키
    /// - example: member/profile/00000000-0000-0000-0000-000000000001.png
    let profileImageKey: String?
    /// 프로필 이미지 URL
    /// - example: https://dev.saion.app/images/profile/00000000-0000-0000-0000-000000000001.png
    let profileImageUrl: String?
    /// 멤버 상태
    /// - example: ACTIVE
    let status: Status
    /// 생성 일시
    /// - example: 2024-01-01T00:00:00
    let createdAt: String

    /// 멤버 아바타 기본 색상
    struct AvatarColor: Decodable {
        /// 아바타 색상 코드
        let code: String
        /// 아바타 색상 hex값
        let hex: String
    }

    /// 멤버 역할
    enum Role: String, Decodable {
        /// 임시 회원
        case pending = "PENDING"
        /// 정회원
        case member = "MEMBER"
        /// 관리자
        case admin = "ADMIN"
    }

    /// 멤버 상태
    enum Status: String, Decodable {
        /// 활성 상태
        case active = "ACTIVE"
        /// 탈퇴 상태
        case deleted = "DELETED"
    }
}

// MARK: - Mapper

extension MyProfileResDTO {
    func toDomain() -> MyProfile? {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.formatOptions = [
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withFractionalSeconds
        ]
        guard let createdAt = formatter.date(from: createdAt) else { return nil }

        return MyProfile(
            memberID: id,
            email: email,
            name: name,
            nickname: nickname,
            role: role.toDomain(),
            avatarColor: MyProfile.AvatarColor(
                code: avatarColor.code,
                hex: avatarColor.hex
            ),
            profileImageKey: profileImageKey,
            profileImageURL: profileImageUrl.flatMap { URL(string: $0) },
            status: status.toDomain(),
            createdAt: createdAt
        )
    }
}

private extension MyProfileResDTO.Role {
    func toDomain() -> MyProfile.Role {
        switch self {
        case .pending: .pending
        case .member: .member
        case .admin: .admin
        }
    }
}

private extension MyProfileResDTO.Status {
    func toDomain() -> MyProfile.Status {
        switch self {
        case .active: .active
        case .deleted: .deleted
        }
    }
}
