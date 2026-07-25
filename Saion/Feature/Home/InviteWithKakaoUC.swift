//
//  InviteWithKakaoUC.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

import KakaoSDKShare

final class InviteWithKakaoUC {
    func execute(invitation: IssuedInvitation) async throws -> URL {
        let templateID: Int64 = 135148
        let myProfile = UserSessionStore.shared.myProfile!
        let currnetCircle = UserSessionStore.shared.currentCircle!
        let expiresAt = {
            let formatter = DateFormatter.seoul
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: invitation.expiresAt)
        }()
        
        let templateArgs = [
            "inviterName": myProfile.nickname,
            "inviteToken": invitation.token,
            "circleName": currnetCircle.name,
            "expiresAt": expiresAt,
            "inviteCode": invitation.invitationID
        ]
        
        guard ShareApi.isKakaoTalkSharingAvailable() else {
            guard let url = ShareApi.shared.makeCustomUrl(
                templateId: templateID,
                templateArgs: templateArgs
            ) else {
                throw SaionError(
                    userMessage: "카카오톡 공유 화면을 열 수 없어요.",
                    errorCode: "IWKUC-E-1"
                )
            }
            return url
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            ShareApi.shared.shareCustom(
                templateId: templateID,
                templateArgs: templateArgs
            ) { result, error in
                guard let url = result?.url else {
                    continuation.resume(throwing: SaionError(
                        with: error,
                        userMessage: "카카오톡 공유 중 문제가 발생했어요.",
                        errorCode: "IWKUC-E-0"
                    ))
                    return
                }
                
                continuation.resume(returning: url)
            }
        }
    }
}
