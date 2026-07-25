//
//  InvitationRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

import Alamofire

protocol InvitationRepo {
    /// 초대장 발급
    func issueInvitation(cirlceID: String) async throws -> IssuedInvitation
    /// 초대장 수락 화면 조회
    func fetchInvitationDetail(token: String) async throws -> InvitationDetail
    /// 초대장 수락
    /// - Returns: 참여한 써클 ID
    func acceptInvitation(token: String) async throws -> String
}

final class DefaultInvitationRepo: InvitationRepo {
    func issueInvitation(cirlceID: String) async throws -> IssuedInvitation {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/invitations",
                method: .post,
                parameters: IssueInvitationReqDTO(targetId: cirlceID),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: IssueInvitationResDTO.self) { dto in
                if let invitation = dto?.toDomain() {
                    continuation.resume(returning: invitation)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "초대장 발급 중 문제가 발생했어요.",
                        errorCode: "IR-II-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "초대장 발급 중 문제가 발생했어요.",
                    errorCode: "IR-II-1"
                ))
            }
            
        }
    }
    
    func fetchInvitationDetail(token: String) async throws -> InvitationDetail {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.plain.request(
                Bundle.main.baseURL + "/api/v1/invitations/\(token)",
                method: .get
            )
            .decodeResponse(decodeType: InvitationDetailResDTO.self) { dto in
                if let invitation = dto?.toDomain() {
                    continuation.resume(returning: invitation)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "초대장 조회 중 문제가 발생했어요.",
                        errorCode: "IR-FID-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "초대장 조회 중 문제가 발생했어요.",
                    errorCode: "IR-FID-1"
                ))
            }
            
        }
    }
    
    func acceptInvitation(token: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/invitations/\(token)",
                method: .post
            )
            .decodeResponse(decodeType: AcceptInvitationResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: dto.circleId)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "초대장 수락 중 문제가 발생했어요.",
                        errorCode: "IR-AI-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "초대장 수락 중 문제가 발생했어요.",
                    errorCode: "IR-AI-1"
                ))
            }
            
        }
    }
}
