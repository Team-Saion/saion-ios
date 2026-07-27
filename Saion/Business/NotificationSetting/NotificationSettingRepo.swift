//
//  NotificationSettingRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Foundation

import Alamofire

protocol NotificationSettingRepo {
    /// 푸시 알림 설정 조회
    func fetchPushNotificationSettings() async throws -> PushNotificationSettings
    /// 푸시 알림 설정 변경
    func updatePushNotificationSettings(
        _ settings: PushNotificationSettings
    ) async throws -> PushNotificationSettings
}

final class DefaultNotificationSettingRepo: NotificationSettingRepo {
    func fetchPushNotificationSettings() async throws -> PushNotificationSettings {
        try await withCheckedThrowingContinuation { continuation in

            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/notification-settings",
                method: .get
            )
            .decodeResponse(decodeType: PushNotificationSettingsResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: dto.toDomain())

                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "푸시 알림 설정 조회 중 문제가 발생했어요.",
                        errorCode: "SR-FPNS-0"
                    ))
                }

            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "푸시 알림 설정 조회 중 문제가 발생했어요.",
                    errorCode: "SR-FPNS-1"
                ))
            }

        }
    }

    func updatePushNotificationSettings(
        _ settings: PushNotificationSettings
    ) async throws -> PushNotificationSettings {
        try await withCheckedThrowingContinuation { continuation in

            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/notification-settings",
                method: .put,
                parameters: PushNotificationSettingsReqDTO(from: settings),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: PushNotificationSettingsResDTO.self) { dto in
                if let dto {
                    continuation.resume(returning: dto.toDomain())

                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "푸시 알림 설정 변경 중 문제가 발생했어요.",
                        errorCode: "SR-UPNS-0"
                    ))
                }

            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "푸시 알림 설정 변경 중 문제가 발생했어요.",
                    errorCode: "SR-UPNS-1"
                ))
            }

        }
    }
}
