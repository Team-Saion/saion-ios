//
//  HomeRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import Foundation

import Alamofire

protocol HomeRepo {
    /// 서클 홈 화면에 사용할 데이터 조회
    func fetchCircleHomeInfo(id: String) async throws -> CircleHomeInfo
    /// 서클 구성원 목록 조회
    func fetchMembers(circleID: String) async throws -> [MemberSummary]
}

final class DefaultHomeRepo: HomeRepo {
    func fetchCircleHomeInfo(id: String) async throws -> CircleHomeInfo {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/homes/\(id)",
                method: .get
            )
            .decodeResponse(decodeType: CircleHomeResDTO.self) { dto in
                if let circleHomeInfo = dto?.toDomain() {
                    continuation.resume(returning: circleHomeInfo)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "서클 홈 정보 조회 중 문제가 발생했어요.",
                        errorCode: "HR-FCHI-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "서클 홈 정보 조회 중 문제가 발생했어요.",
                    errorCode: "HR-FCHI-1"
                ))
            }
            
        }
    }
    
    func fetchMembers(circleID: String) async throws -> [MemberSummary] {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/homes/\(circleID)/members",
                method: .get
            )
            .decodeResponse(decodeType: [MemberSummaryResDTO].self) { dto in
                if let dto {
                    continuation.resume(returning: dto.map { $0.toDomain() })
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "서클 구성원 조회 중 문제가 발생했어요.",
                        errorCode: "HR-FM-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "서클 구성원 조회 중 문제가 발생했어요.",
                    errorCode: "HR-FM-1"
                ))
            }
            
        }
    }
}
