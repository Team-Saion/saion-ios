//
//  LoginRepo.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import Alamofire

protocol LoginRepo {
    /// 카카오 아이디 토큰으로 사이온 로그인
    func requestLoginWithKakao(
        idToken: String
    ) async throws -> (
        accessToken: String,
        refreshToken: String,
        role: AuthState.Role
    )
}

final class DefaultLoginRepo: LoginRepo {
    func requestLoginWithKakao(
        idToken: String
    ) async throws -> (
        accessToken: String,
        refreshToken: String,
        role: AuthState.Role
    ) {
        try await withCheckedThrowingContinuation { continuation in
            
            APISession.plain.request(
                Bundle.main.baseUrl + "/api/v1/auth/kakao",
                method: .post,
                parameters: KakaoLoginReqDTO(idToken: idToken),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: TokenResDTO.self) { [weak self] dto in
                if let dto, let role = self?.decodeRole(from: dto.accessToken) {
                    continuation.resume(returning: (
                        dto.accessToken,
                        dto.refreshToken,
                        role
                    ))
                    
                } else {
                    continuation.resume(throwing: SaionError(
                        userMessage: "사용자 인증 중 문제가 발생했어요.",
                        errorCode: "LR-RLWK-0"
                    ))
                }
                
            } errorHandler: { error in
                continuation.resume(throwing: SaionError(
                    with: error,
                    userMessage: "사용자 인증 중 문제가 발생했어요.",
                    errorCode: "LR-RLWK-1"
                ))
            }
            
        }
    }
    
    // MARK: Private Helper
    
    /// JWT 페이로드에서 role 값을 디코딩하여 반환
    private func decodeRole(from jwtToken: String) -> AuthState.Role? {
        let segments = jwtToken.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        // Base64url 포맷을 Base64 표준 포맷으로 변환해
        var base64 = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // 4의 배수가 되도록 패딩(=)을 추가해
        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(String(repeating: "=", count: 4 - remainder))
        }
        
        // Data를 JSON 객체로 변환하여 roles 배열의 첫 번째 요소를 추출
        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let roleStr = (json["roles"] as? [String])?.first,
              let role = AuthState.Role(rawValue: roleStr)
        else { return nil }
        
        return role
    }
}
