//
//  SaionError.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Foundation

struct SaionError: LocalizedError {
    /// 실제 발생한 원본 에러
    let underlyingError: Error?
    /// 사용자에게 보여줄 커스텀 메시지
    let userMessage: String?
    /// 에러 식별을 위한 고유 코드
    let errorCode: String
    
    /// 화면에 노출할 최종 에러 설명
    var errorDescription: String? {
        let message = [userMessage, (underlyingError as? LocalizedError)?.errorDescription]
            .compactMap { $0 }
            .joined(separator: "\n")
        
        return "\(message.isEmpty ? "알 수 없는 문제가 발생했어요." : message)\n(에러코드: \(errorCode))"
    }
    
    // MARK: Initializer
    
    init(
        with underlyingError: Error? = nil,
        userMessage: String?,
        errorCode: String
    ) {
        self.underlyingError = underlyingError
        self.userMessage = userMessage
        self.errorCode = errorCode
    }
}
