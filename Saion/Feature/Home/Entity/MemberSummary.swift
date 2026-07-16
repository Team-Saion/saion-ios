//
//  MemberSummary.swift
//  Saion
//
//  Created by 신정욱 on 7/16/26.
//

import Foundation

/// 서클 구성원 요약
struct MemberSummary: Hashable {
    /// 구성원 ID
    let memberID: String
    /// 닉네임
    let nickname: String
    /// 아바타 색상
    let avatarColor: String
    /// 내 계정 여부
    let isMe: Bool
    /// 구성원 역할
    let role: String
    /// 프로필 사진 주소
    let profileImageURL: URL?
}
