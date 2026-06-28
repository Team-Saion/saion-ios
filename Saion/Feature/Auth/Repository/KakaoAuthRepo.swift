//
//  KakaoAuthRepo.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

protocol KakaoAuthRepo {
    /// 카카오 소셜 로그인을 통해 아이디 토큰 가져오기
    func fetchKakaoIDToken() async throws -> String
}

final class DefaultKakaoAuthRepo: KakaoAuthRepo {
    func fetchKakaoIDToken() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            
            /// 공통된 결과 처리 클로저
            let completion: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                if let idToken = oauthToken?.idToken {
                    continuation.resume(returning: idToken)
                    
                } else if let error {
                    continuation.resume(throwing: SaionError(
                        with: error,
                        userMessage: "카카오 인증 중 문제가 발생했어요.",
                        errorCode: "KAR-FKAT-0"
                    ))
                }
            }
            
            // 카카오톡 앱 설치 여부에 따라 최적의 로그인 수단을 선택 (앱, 계정)
            UserApi.isKakaoTalkLoginAvailable()
            ? UserApi.shared.loginWithKakaoTalk(completion: completion)
            : UserApi.shared.loginWithKakaoAccount(completion: completion)
            
        }
    }
}

