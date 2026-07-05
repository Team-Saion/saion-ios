//
//  OnboardingInfoResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/2/26.
//

import UIKit

/// 온보딩 사전정보 응답 DTO
struct OnboardingInfoResDTO: Decodable {
    /// 소셜 플랫폼 프로필 닉네임
    let socialNickname: String?
    /// 소셜 플랫폼 프로필 이미지 URL
    let socialProfileImageUrl: String?
    /// 멤버 아바타 기본 색상
    let avatarColor: AvatarColor
    
    /// 멤버 아바타 기본 색상
    struct AvatarColor: Decodable {
        /// 아바타 색상 코드
        let code: String
        /// 아바타 색상 hex값
        let hex: String
    }
    
    // MARK: Mapper
    
    func toDomain() -> OnboardingInfo {
        /// http로 시작하는 URL이 들어올 경우, https로 강제 변환
        let profileImageURL = socialProfileImageUrl?.replacingOccurrences(
            of: "http://",
            with: "https://"
        )
        
        return OnboardingInfo(
            nickname: socialNickname?.isEmpty == false ? socialNickname : nil,
            profileImageURL: profileImageURL.flatMap { URL(string: $0) },
            avatarColor: .hex(hexStr: avatarColor.hex)
        )
    }
}

// MARK: - UIColor Extension

fileprivate extension UIColor {
    static func hex(hexStr: String) -> UIColor {
        var hexString = hexStr
        
        if hexString.hasPrefix("#") { hexString.remove(at: hexString.startIndex) }
        
        guard hexString.count == 6 else { return .black }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xff00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xff) / 255.0
        
        return .init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
