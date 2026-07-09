//
//  CircleRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import Foundation

import Alamofire

protocol CircleRepo {
    /// 소속된 서클 목록 조회
    func fetchJoinedCircles() async throws -> [CircleSummary]
    /// 서클 생성 요청
    func createCircle(name: String?) async throws -> CircleSummary
}

final class DefaultCircleRepo: CircleRepo {
    func fetchJoinedCircles() async throws -> [CircleSummary] {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles",
                method: .get
            )
            .decodeResponse(decodeType: [CircleSummaryResDTO].self) { dtos in
                if let dtos {
                    continuation.resume(returning: dtos.toDomains())
                    
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "써클 목록 조회 중 문제가 발생했어요.",
                        errorCode: "CR-FJC-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "써클 목록 조회 중 문제가 발생했어요.",
                    errorCode: "CR-FJC-1"
                ))
            }
            
        }
    }
    
    func createCircle(name: String?) async throws -> CircleSummary {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles",
                method: .post,
                parameters: CreateCircleReqDTO(name: name),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: CircleSummaryResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: dto.toDomain())
                    
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "서클 생성 중 문제가 발생했어요.",
                        errorCode: "CR-CC-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "서클 생성 중 문제가 발생했어요.",
                    errorCode: "CR-CC-1"
                ))
            }
            
        }
    }
}
