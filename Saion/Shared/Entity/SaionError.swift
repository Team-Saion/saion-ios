//
//  SaionError.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Foundation

struct SaionError: LocalizedError {
    /// 실제 발생한 원본 에러
    let underlyingError: LocalizedError?
    /// 사용자에게 보여줄 커스텀 메시지
    let userMessage: String?
    /// 에러 식별을 위한 고유 코드
    let errorCode: String
    
    /// 화면에 노출할 최종 에러 설명
    /// 원본 에러 설명, 사용자 메시지, 기본 에러 문구 순으로 우선순위를 가짐
    var errorDescription: String? {
        let message = [underlyingError?.errorDescription, userMessage]
            .compactMap { $0 }
            .first { !$0.isEmpty }
        ?? "알 수 없는 문제가 발생했어요."
        
        return "\(message)\n(에러코드: \(errorCode))"
    }
    
    // MARK: Initializer
    
    init(
        with underlyingError: LocalizedError? = nil,
        userMessage: String?,
        errorCode: String
    ) {
        self.underlyingError = underlyingError
        self.userMessage = userMessage
        self.errorCode = errorCode
    }
}
