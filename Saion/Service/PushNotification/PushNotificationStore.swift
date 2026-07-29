//
//  PushNotificationStore.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Combine
import UIKit

import CasePaths
import FirebaseInstallations
import FirebaseMessaging

// TODO: 나중에 매니저와 병합시키는 게 깔끔할 듯 하다.
final class PushNotificationStore {
    
    // MARK: Types
    
    enum Action {
        /// 인증 상태 변경됨
        case authStateChanged(isSignedIn: Bool)
        /// APNs 토큰 등록 완료
        case apnsTokenRegistered(Data)
        /// FCM 토큰 수신 완료
        case fcmTokenReceived(String)
    }
    
    struct State {}
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    private let fcmTokenRepo: FCMTokenRepo
    
    // MARK: Initializer
    
    init(fcmTokenRepo: FCMTokenRepo) {
        self.fcmTokenRepo = fcmTokenRepo
    }
    
    // MARK: Send
    
    func send(_ action: Action) {
        Task { @MainActor in
            do {
                try await process(action: action)
            } catch let error as LocalizedError {
                effect.send(.presentError(error))
            }
        }
    }
    
    // MARK: Process
    
    private func process(action: Action) async throws {
        switch action {
        case .authStateChanged(let isSignedIn):
            if isSignedIn, try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.badge, .sound, .alert]) {
                // 권한 허용 이후 메인 스레드에서 실제 원격 알림 등록 진행
                // Firebase가 FCM 등록 토큰을 자동 생성하고 갱신하도록 허용
                Messaging.messaging().isAutoInitEnabled = true
                // iOS에 APNs 원격 알림 등록 요청
                await UIApplication.shared.registerForRemoteNotifications()
                
            } else {
                // iOS 원격 알림 수신 등록 해제
                await UIApplication.shared.unregisterForRemoteNotifications()
                // Firebase의 FCM 토큰 자동 생성과 갱신 비활성화
                Messaging.messaging().isAutoInitEnabled = false
            }
            
        case .apnsTokenRegistered(let apnsToken):
            // APNs 토큰을 Firebase에 전달해 FCM 푸시 수신 경로를 연결
            Messaging.messaging().apnsToken = apnsToken
            
        case .fcmTokenReceived(let fcmToken):
            let installationID = try await Installations.installations().installationID()
            // 토큰이 새로 발급되거나 갱신되면 서버에 동기화
            try await fcmTokenRepo.register(token: fcmToken, installationID: installationID)
        }
    }
}
