//
//  NotificationRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Foundation

import Alamofire

protocol NotificationRepo {
    /// 알림 보관함 조회
    func fetchInbox(
        cursor: String?
    ) async throws -> Pagenation<InboxItem>
}

final class DefaultNotificationRepo: NotificationRepo {
    func fetchInbox(
        cursor: String?
    ) async throws -> Pagenation<InboxItem> {
        try await withCheckedThrowingContinuation { continuation in
            
            var parameters: [String: Any] = ["size": 20]
            if let cursor { parameters["cursor"] = cursor }
            
            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/notifications",
                method: .get,
                parameters: parameters
            )
            .decodeResponse(decodeType: InboxResDTO.self) { dto in
                if let page = dto?.toDomain() {
                    continuation.resume(returning: page)
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "알림 목록 조회 중 문제가 발생했어요.",
                        errorCode: "NR-FN-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "알림 목록 조회 중 문제가 발생했어요.",
                    errorCode: "NR-FN-1"
                ))
            }
            
        }
    }
}
