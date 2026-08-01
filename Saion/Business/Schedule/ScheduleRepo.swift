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
    
    /// 일정 목록 조회
    func fetchSchedules(
        circleID: String,
        cursor: String?
    ) async throws -> Pagenation<ScheduleSummary>
    
    /// 일정 상세 조회
    func fetchScheduleDetail(
        circleID: String,
        scheduleID: String
    ) async throws -> Schedule
    
    /// 일정 삭제
    func deleteSchedule(
        circleID: String,
        scheduleID: String
    ) async throws
    
    /// 일정 확인 등록
    func setConfirmed(
        circleID: String,
        scheduleID: String
    ) async throws
    
    /// 일정 확인 취소
    func setUnconfirmed(
        circleID: String,
        scheduleID: String,
        confirmationID: Int
    ) async throws
    
    /// 일정 내용을 가족에게 전달
    func requestFamilyNotification(
        circleID: String,
        scheduleID: String
    ) async throws
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
    
    func fetchSchedules(
        circleID: String,
        cursor: String?
    ) async throws -> Pagenation<ScheduleSummary> {
        try await withCheckedThrowingContinuation { continuation in
            
            var parameters: [String: Any] = ["circleId": circleID, "size": 20]
            if let cursor { parameters["cursor"] = cursor }
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles/\(circleID)/schedules",
                method: .get,
                parameters: parameters
            )
            .decodeResponse(decodeType: ScheduleSummariesResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: dto.toDomain())
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "일정 목록 조회 중 문제가 발생했어요.",
                        errorCode: "SR-FS-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "일정 목록 조회 중 문제가 발생했어요.",
                    errorCode: "SR-FS-1"
                ))
            }
            
        }
    }
    
    func fetchScheduleDetail(
        circleID: String,
        scheduleID: String
    ) async throws -> Schedule {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles/\(circleID)/schedules/\(scheduleID)",
                method: .get
            )
            .decodeResponse(decodeType: ScheduleResDTO.self) { dto in
                if let domain = dto?.toDomain() {
                    continuation.resume(returning: domain)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "일정 상세 조회 중 문제가 발생했어요.",
                        errorCode: "SR-FSD-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "일정 상세 조회 중 문제가 발생했어요.",
                    errorCode: "SR-FSD-1"
                ))
            }
            
        }
    }
    
    func deleteSchedule(
        circleID: String,
        scheduleID: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles/\(circleID)/schedules/\(scheduleID)",
                method: .delete
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                continuation.resume(returning: ())
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "일정 삭제 중 문제가 발생했어요.",
                    errorCode: "SR-DS-0"
                ))
            }
            
        }
    }
    
    func setConfirmed(
        circleID: String,
        scheduleID: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles/\(circleID)/schedules/\(scheduleID)/confirmations",
                method: .post,
                parameters: RegisterConfirmationReqDTO(confirmationType: .confirmed),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: RegisterConfirmationResDTO.self) { _ in
                continuation.resume(returning: ())
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "일정 확인 중 문제가 발생했어요.",
                    errorCode: "SR-SC-0"
                ))
            }
            
        }
    }
    
    func setUnconfirmed(
        circleID: String,
        scheduleID: String,
        confirmationID: Int
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles/\(circleID)/schedules/\(scheduleID)/confirmations/\(confirmationID)",
                method: .delete
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                continuation.resume(returning: ())
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "일정 확인 취소 중 문제가 발생했어요.",
                    errorCode: "SR-SU-0"
                ))
            }
            
        }
    }
    
    func requestFamilyNotification(
        circleID: String,
        scheduleID: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/circles/\(circleID)/schedules/\(scheduleID)/family-notifications",
                method: .post
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                continuation.resume(returning: ())
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "가족에게 일정 전달 중 문제가 발생했어요.",
                    errorCode: "SR-RFN-0"
                ))
            }
            
        }
    }
}
