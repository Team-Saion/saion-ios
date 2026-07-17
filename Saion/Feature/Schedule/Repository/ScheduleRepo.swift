//
//  ScheduleRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Foundation

import Alamofire

protocol ScheduleRepo {
    /// 일정 생성 요청
    /// - Returns: 일정 ID
    func createSchedule(
        from draft: ScheduleDraft,
        _ circleID: String
    ) async throws -> String
}

final class DefaultScheduleRepo: ScheduleRepo {
    func createSchedule(
        from draft: ScheduleDraft,
        _ circleID: String
    ) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles/\(circleID)/schedules",
                method: .post,
                parameters: CreateScheduleReqDTO(from: draft),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: CreateScheduleResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: dto.scheduleId)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "일정 생성 중 문제가 발생했어요.",
                        errorCode: "SR-CS-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "일정 생성 중 문제가 발생했어요.",
                    errorCode: "SR-CS-1"
                ))
            }
            
        }
    }
}
