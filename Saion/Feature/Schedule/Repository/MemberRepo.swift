//
//  MemberRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/18/26.
//

import Foundation

import Alamofire

protocol MemberRepo {
    /// 내 프로필 조회
    func fetchMyProfile() async throws -> MyProfile
}

final class DefaultMemberRepo: MemberRepo {
    func fetchMyProfile() async throws -> MyProfile {
        try await withCheckedThrowingContinuation { continuation in

            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/members/me",
                method: .get
            )
            .decodeResponse(decodeType: MyProfileResDTO.self) { dto in
                if let myProfile = dto?.toDomain() {
                    continuation.resume(returning: myProfile)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "프로필 조회 중 문제가 발생했어요.",
                        errorCode: "MR-FMP-0"
                    ))
                }

            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "프로필 조회 중 문제가 발생했어요.",
                    errorCode: "MR-FMP-1"
                ))
            }

        }
    }
}
