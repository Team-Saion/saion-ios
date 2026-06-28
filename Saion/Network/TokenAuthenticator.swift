//
//  TokenAuthenticator.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import Alamofire

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
            Bundle.main.baseUrl + "/api/v1/auth/refresh",
            method: .post,
            parameters: RefreshTokenReqDTO(from: credential.refreshToken),
            encoder: JSONParameterEncoder.default
        )
        .decodeResponse(decodeType: TokenResDTO.self) { dto in
            if let dto {
                credential.store.send(.userDidLogin(
                    accessToken: dto.accessToken,
                    refreshToken: dto.refreshToken
                ))
                completion(.success(credential))
                
            } else {
                completion(.failure(APIError(
                    message: "토큰 재발급에 실패했습니다.(TA-R-1)"
                )))
            }
            
        } errorHandler: { error in
            completion(.failure(error))
        }
    }
}


