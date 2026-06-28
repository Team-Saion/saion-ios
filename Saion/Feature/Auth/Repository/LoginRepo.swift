//
//  LoginRepo.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import Alamofire

protocol LoginRepo {
    /// 카카오 아이디 토큰으로 사이온 로그인
    func requestLoginWithKakao(
        idToken: String
    ) async throws -> (
        accessToken: String,
        refreshToken: String
    )
}

final class DefaultLoginRepo: LoginRepo {
    func requestLoginWithKakao(
        idToken: String
    ) async throws -> (
        accessToken: String,
        refreshToken: String
    ) {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.plain.request(
                Bundle.main.baseUrl + "/api/v1/auth/kakao",
                method: .post,
                parameters: KakaoLoginReqDTO(idToken: idToken),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: TokenResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: (dto.accessToken, dto.refreshToken))
                    
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "사용자 인증 중 문제가 발생했어요.",
                        errorCode: "LR-RLWK-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "사용자 인증 중 문제가 발생했어요.",
                    errorCode: "LR-RLWK-1"
                ))
            }
            
        }
    }
}
