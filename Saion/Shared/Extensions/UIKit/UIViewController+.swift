//
//  UIViewController+.swift
//  Saion
//
//  Created by 신정욱 on 7/1/26.
//

import Combine
import UIKit

import CombineCocoa

import DesignSystem

extension UIViewController {
    func presentErrorAlert(error: LocalizedError) {
        let alert = NoticeAlertVC()
        alert.titleLabel.text = "문제가 발생했어요"
        alert.descriptionLabel.text = error.errorDescription
        
        // 확인버튼 탭하면 닫기
        alert.acceptButton.tapPublisher
            .sink { [weak alert] in alert?.dismiss(animated: true) }
            .store(in: &alert.cancellables)
        
        // 화면 전환
        present(alert, animated: true)
    }
}
