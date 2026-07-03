//
//  OnboardingRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/2/26.
//

import Foundation

import Alamofire

protocol OnboardingRepo {
    /// 온보딩 프리필 데이터 조회
    func fetchOnboardingInfo() async throws -> OnboardingInfo
    /// 온보딩 완료 요청
    func completeOnboarding(
        nickname: String
    ) async throws -> (accessToken: String, refreshToken: String)
}

final class DefaultOnboardingRepo: OnboardingRepo {
    func fetchOnboardingInfo() async throws -> OnboardingInfo {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/members/me/onboarding-info",
                method: .get
            )
            .decodeResponse(decodeType: OnboardingInfoResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: dto.toDomain())
                    
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "사전 정보 조회 중 문제가 발생했어요.",
                        errorCode: "OR-FOI-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "사전 정보 조회 중 문제가 발생했어요.",
                    errorCode: "OR-FOI-1"
                ))
            }
            
        }
    }
    
    func completeOnboarding(
        nickname: String
    ) async throws -> (accessToken: String, refreshToken: String) {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/members/me/onboarding",
                method: .patch,
                parameters: OnboardingReqDTO(nickname: nickname),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: TokenResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: (
                        dto.accessToken,
                        dto.refreshToken
                    ))
                    
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "온보딩 완료 중 문제가 발생했어요.",
                        errorCode: "OR-CO-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "온보딩 완료 중 문제가 발생했어요.",
                    errorCode: "OR-CO-1"
                ))
            }
            
        }
    }
}
