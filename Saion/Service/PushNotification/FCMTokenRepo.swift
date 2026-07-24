//
//  FCMTokenRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

import Alamofire

protocol FCMTokenRepo {
    /// FCM 푸시 토큰 등록
    func register(token: String, installationID: String) async throws
}

final class DefaultFCMTokenRepo: FCMTokenRepo {
    func register(token: String, installationID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/push-tokens",
                method: .post,
                parameters: RegisterFCMTokenReqDTO(
                    installationId: installationID,
                    token: token,
                    platform: .ios
                ),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: RegisterFCMTokenResDTO.self) { _ in
                continuation.resume(returning: ())
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "푸시 토큰 등록 중 문제가 발생했어요.",
                    errorCode: "FTR-R-0"
                ))
            }
            
        }
    }
}
