//
//  MyPageCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import Combine
import UIKit

import CombineCocoa

import Navigation

final class MyPageCoord: Coordinator {
    
    // MARK: Start
    
    func start() {
        let vc = MyPageVC()
        
        // 회원 탈퇴 메뉴 탭 시 탈퇴 사유 입력 화면으로 이동
        vc.deleteAccountTapPublisher
            .sink { [weak self] in self?.pushDeleteAccountReasonVC() }
            .store(in: &cancellables)
        
        // 푸시 알림 설정 탭하면 설정 화면으로 이동
        vc.notificationTapPublisher
            .sink { [weak self] in self?.puahPushNotificationSettingsVC() }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }
    
    /// 탈퇴 사유 입력 화면으로 이동
    private func pushDeleteAccountReasonVC() {
        let vc = DeleteAccountReasonVC()
        vc.hidesDefaultTabBarWhenPushed = true
        
        // 뒤로가기
        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
    
    /// 푸시 알림 설정 화면으로 이동
    private func puahPushNotificationSettingsVC() {
        let vc = PushNotificationSettingsVC()
        vc.hidesDefaultTabBarWhenPushed = true
        
        // 뒤로가기
        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
}
