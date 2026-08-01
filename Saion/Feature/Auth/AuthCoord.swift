//
//  AuthCoord.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Combine
import UIKit

final class AuthCoord: Coordinator {
    func start() {
        let vc = LoginVC()
        
        // 로그인 완료 이벤트를 프로필 입력 화면 전환으로 연결
        vc.pushProfileInputPublisher
            .sink { [weak self] in self?.pushProfileInput(onboardingInfo: $0) }
            .store(in: &vc.cancellables)
        
        navigation.pushViewController(vc, animated: false)
    }

    // MARK: Routing
    
    func pushProfileInput(onboardingInfo: OnboardingInfo) {
        let vm = AuthDI.shared.makeProfileInputVM(onboardingInfo: onboardingInfo)
        let vc = ProfileInputVC(vm: vm)
        
        navigation.pushViewController(vc, animated: true)
    }
}
