//
//  AuthCoord.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Combine
import UIKit

import CombineCocoa

final class AuthCoord: Coordinator {
    func start() {
        let vc = LoginVC()
        
        vc.pushProfileInputPublisher
            .sink { [weak self] in self?.pushProfileInput(onboardingInfo: $0) }
            .store(in: &cancellables)
        
        navigation.pushViewController(vc, animated: false)
    }
    
    func pushProfileInput(onboardingInfo: OnboardingInfo) {
        let vm = AuthDI.shared.makeProfileInputVM(onboardingInfo: onboardingInfo)
        let vc = ProfileInputVC(vm: vm)
        
        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        navigation.pushViewController(vc, animated: true)
    }
}
