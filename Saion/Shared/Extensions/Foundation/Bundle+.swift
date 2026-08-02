//
//  Bundle+.swift
//  Saion
//
//  Created by Antigravity on 6/27/26.
//

import Foundation

extension Bundle {
    /// Info.plist에 등록된 앱 환경설정 딕셔너리
    private var appEnvironment: [String: Any] {
        return infoDictionary?["AppEnvironment"] as? [String: Any] ?? [:]
    }
    
    /// API 서버 기본 URL
    var baseURL: String {
        guard let baseUrl = appEnvironment["BASE_URL"] as? String else {
            preconditionFailure("AppEnvironment에 BASE_URL이 누락되었어.")
        }
        return baseUrl
    }
    
    /// 카카오 네이티브 앱 키
    var kakaoNativeAppKey: String {
        guard let kakaoKey = appEnvironment["KAKAO_NATIVE_APP_KEY"] as? String else {
            preconditionFailure("AppEnvironment에 KAKAO_NATIVE_APP_KEY가 누락되었어.")
        }
        return kakaoKey
    }
    
    /// 데모 계정 액세스 토큰
    var demoAccessToken: String {
        guard let token = appEnvironment["DEMO_ACCESS_TOKEN"] as? String else {
            preconditionFailure("AppEnvironment에 DEMO_ACCESS_TOKEN이 누락되었어.")
        }
        return token
    }
}
