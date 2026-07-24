//
//  PushNotificationManager.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Combine
import UIKit

import FirebaseCore
import FirebaseMessaging

final class PushNotificationManager: NSObject {
    
    // MARK: Singleton
    
    static let shared = PushNotificationManager()
    private override init() {}
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let store = PushNotificationStore(fcmTokenRepo: DefaultFCMTokenRepo())
    
    // MARK: Configure
    
    /// 앱 실행 시 푸시 알림 관련 SDK와 delegate를 초기화
    func configure() {
        // Firebase SDK 초기화
        FirebaseApp.configure()
        // FCM 토큰 갱신 이벤트 수신
        Messaging.messaging().delegate = self
        // 포그라운드 알림과 알림 탭 이벤트 수신
        UNUserNotificationCenter.current().delegate = self
        // 이벤트 바인딩 시작
        setupBindings()
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 로그인 상태 변경에 따라 푸시 등록 또는 해제를 요청
        AuthManager.shared.authStatePublisher
            .sink { [weak self] in self?.store.send(.authStateChanged($0)) }
            .store(in: &cancellables)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    /// APNs 디바이스 토큰 등록이 완료되면 토큰을 Store에 전달
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        store.send(.apnsTokenRegistered(deviceToken))
    }
    
    /// 앱이 포그라운드 상태일 때 도착한 알림을 처리
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound, .badge])
    }
    
    /// 사용자가 알림을 탭했을 때 필요한 후속 처리를 수행
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        _ = response.notification.request.content.userInfo
        completionHandler()
    }
}

// MARK: - MessagingDelegate

extension PushNotificationManager: MessagingDelegate {
    /// Firebase가 신규 또는 갱신된 FCM 토큰을 전달하면 Store에 전달
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken else { return }
        store.send(.fcmTokenReceived(fcmToken))
    }
}
