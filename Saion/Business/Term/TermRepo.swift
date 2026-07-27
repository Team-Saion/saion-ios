//
//  TermRepo.swift
//  Saion
//
//  Created by 신정욱 on 7/27/26.
//

import Foundation

import Alamofire

protocol TermRepo {
    /// 약관 동의 요청
    func agreeToTerms() async throws
}

final class DefaultTermRepo: TermRepo {
    func agreeToTerms() async throws {
        try await withCheckedThrowingContinuation { continuation in

            APISession.withAuth.request(
                Bundle.main.baseURL + "/api/v1/terms/agree",
                method: .post,
                parameters: TermsAgreementReqDTO(),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                continuation.resume(returning: ())

            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "약관 동의 처리 중 문제가 발생했어요.",
                    errorCode: "OR-ATT-0"
                ))
            }

        }
    }
}
