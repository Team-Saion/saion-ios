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
    /// 온보딩 프리필 데이터 조회
    func fetchOnboardingInfo() async throws -> OnboardingInfo
    /// 온보딩 완료 요청
    func completeOnboarding(nickname: String) async throws -> TokenInfo
    /// 회원 탈퇴
    func deleteAccount(reason: String) async throws
    /// 로그아웃
    func logout() async throws
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
    
    func completeOnboarding(nickname: String) async throws -> TokenInfo {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/members/me/onboarding",
                method: .patch,
                parameters: OnboardingReqDTO(nickname: nickname),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: TokenResDTO.self) { dto in
                if let tokenInfo = dto?.toDomain() {
                    continuation.resume(returning: tokenInfo)
                    
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
    
    func deleteAccount(reason: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/members/me",
                method: .delete,
                parameters: DeleteAccountDTO(reason: reason),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                continuation.resume(returning: ())
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "회원 탈퇴 중 문제가 발생했어요.",
                    errorCode: "MR-DA-0"
                ))
            }
            
        }
    }
    
    func logout() async throws {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/members/me/logout",
                method: .post
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                continuation.resume(returning: ())
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "로그아웃 중 문제가 발생했어요.",
                    errorCode: "MR-L-0"
                ))
            }
            
        }
    }
}
