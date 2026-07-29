//
//  TokenAuthenticator.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import Alamofire

import DesignSystem

final class TokenAuthenticator: Authenticator {
    
    typealias Credential = AuthManager
    
    func apply(
        _ credential: Credential,
        to urlRequest: inout URLRequest
    ) {
        guard let accessToken = credential.accessToken else { return }
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
    }
    
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: any Error
    ) -> Bool {
        response.statusCode == 401
    }
    
    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: Credential
    ) -> Bool {
        guard let accessToken = credential.accessToken else { return false }
        return urlRequest.headers["Authorization"] == "Bearer \(accessToken)"
    }
    
    func refresh(
        _ credential: Credential,
        for session: Session,
        completion: @escaping (Result<Credential, any Error>) -> Void
    ) {
        APISession.plain.request(
            Bundle.main.baseURL + "/api/v1/auth/refresh",
            method: .post,
            parameters: RefreshTokenReqDTO(from: credential.refreshToken),
            encoder: JSONParameterEncoder.default
        )
        .decodeResponse(decodeType: TokenResDTO.self) { dto in
            if let tokenInfo = dto?.toDomain() {
                // 새 토큰을 저장하고 대기 중인 인증 요청을 재시도
                credential.send(.tokensDidRefresh(tokenInfo: tokenInfo))
                completion(.success(credential))
                
            } else {
                // 토큰 응답이 없으면 인증 상태를 초기화하고 로그인 화면으로 전환
                AlertCenter.shared.send(.presentError(SaionError(
                    userMessage: "로그인이 만료됐어요. 다시 로그인해 주세요.",
                    errorCode: "TA-R-0"
                )))
                credential.send(.userDidLogout)
                completion(.failure(APIError(
                    message: "토큰 재발급에 실패했습니다.(TA-R-0)"
                )))
            }
            
        } errorHandler: { error in
            // 재발급 요청이 실패하면 인증 상태를 초기화하고 로그인 화면으로 전환
            AlertCenter.shared.send(.presentError(SaionError(
                userMessage: "로그인이 만료됐어요. 다시 로그인해 주세요.",
                errorCode: "TA-R-1"
            )))
            credential.send(.userDidLogout)
            completion(.failure(error))
        }
    }
}
