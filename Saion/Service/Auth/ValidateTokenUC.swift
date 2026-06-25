//
//  ValidateTokenUC.swift
//  Saion
//
//  Created by 신정욱 on 6/25/26.
//

import Foundation

/// 토큰 유효성 검증 유즈케이스 (유효기간 파싱)
final class ValidateTokenUC {
    
    /// 만료 5분 전이거나 이미 만료되었다면 false 반환
    func execute(with token: String?) -> Bool {
        guard let token else {
            print("[ValidateTokenUC] 유효기간 파싱할 토큰 없음")
            return false
        }
        
        guard let expireAt = parseTokenExpiration(token) else {
            print("[ValidateTokenUC] 토큰 유효기간 파싱 실패")
            return false
        }
        
        /// 토큰 만료 여부 (만료 5분 이내일 경우 만료 처리)
        let isExpired = Date(timeIntervalSinceNow: 60*5) > expireAt
        
        // 토큰 유효기간 디버깅
        let formatter = DateFormatter.seoul
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let expireAtStr = formatter.string(from: expireAt)
        print("[ValidateTokenUC] 토큰 유효기간 \(expireAtStr) (\(isExpired ? "만료" : "유효"))")
        
        // 유효한지 여부를 반환해야 하므로 결과값을 반전
        return !isExpired
    }
    
    // MARK: Private Helper
    
    /// 토큰 유효기간 파싱
    private func parseTokenExpiration(_ token: String?) -> Date? {
        guard let token else { return nil }
        
        // 토큰을 . 으로 분리
        let segments = token.components(separatedBy: ".")
        guard let payloadSegment = segments[safe: 1] else { return nil }
        
        // Base64 디코딩
        var base64 = payloadSegment
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // padding 복구
        while base64.count%4 != 0 { base64 += "=" }
        
        guard
            let payloadData = Data(base64Encoded: base64),
            let payloadJSON = try? JSONSerialization
                .jsonObject(with: payloadData) as? [String: Any],
            let exp = payloadJSON["exp"] as? TimeInterval
        else { return nil }
        
        return Date(timeIntervalSince1970: exp)
    }
}
