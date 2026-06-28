//
//  APIError.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

struct APIError: LocalizedError, Decodable {
    /// 에러 코드
    let errorCode: String?
    /// 에러 메시지
    let message: String?
    /// 응답 시각 (예: "2024-01-01T00:00:00")
    let timestamp: Date?
    
    var errorDescription: String? { message }
    
    init(
        errorCode: String? = nil,
        message: String?,
        timestamp: Date? = nil
    ) {
        self.errorCode = errorCode
        self.message = message
        self.timestamp = timestamp
    }
}
