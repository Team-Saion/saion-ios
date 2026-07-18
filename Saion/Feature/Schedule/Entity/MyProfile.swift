//
//  MyProfile.swift
//  Saion
//
//  Created by 신정욱 on 7/18/26.
//

import Foundation

/// 내 프로필 정보
struct MyProfile: Hashable {
    /// 멤버 ID
    let memberID: String
    /// 이메일
    let email: String?
    /// 이름
    let name: String?
    /// 닉네임
    let nickname: String
    /// 멤버 역할
    let role: Role
    /// 멤버 아바타 기본 색상
    let avatarColor: AvatarColor
    /// 프로필 이미지 키
    let profileImageKey: String?
    /// 프로필 이미지 URL
    let profileImageURL: URL?
    /// 멤버 상태
    let status: Status
    /// 생성 일시
    let createdAt: Date

    /// 멤버 아바타 기본 색상
    struct AvatarColor: Hashable {
        /// 아바타 색상 코드
        let code: String
        /// 아바타 색상 hex값
        let hex: String
    }

    /// 멤버 역할
    enum Role: Hashable {
        /// 임시 회원
        case pending
        /// 정회원
        case member
        /// 관리자
        case admin
    }

    /// 멤버 상태
    enum Status: Hashable {
        /// 활성 상태
        case active
        /// 탈퇴 상태
        case deleted
    }
}
