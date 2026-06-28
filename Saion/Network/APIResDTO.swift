//
//  APIResDTO.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

/// 공통 응답 DTO
struct APIResDTO<T: Decodable>: Decodable {
    /// 요청 성공 여부
    let success: Bool
    /// 응답 데이터 (실패 시 null)
    let data: T?
    /// 에러 코드 (성공 시 null)
    let errorCode: String?
    /// 에러 메시지 (성공 시 null)
    let message: String?
    /// 응답 시각 (예: "2024-01-01T00:00:00")
    let timestamp: String
    
    // MARK: Mappers
    
    func toAPIError() -> APIError {
        let formatter = DateFormatter.seoul
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return APIError(
            errorCode: errorCode,
            message: message,
            timestamp: formatter.date(from: timestamp)
        )
    }
}

