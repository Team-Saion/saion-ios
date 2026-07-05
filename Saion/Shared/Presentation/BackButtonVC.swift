//
//  BackButtonVC.swift
//  Saion
//
//  Created by 신정욱 on 7/2/26.
//

import UIKit

import DesignSystem
import Navigation

class BackButtonVC: NavigationBarVC {
    
    // MARK: Components
    
    /// 뒤로가기 바 버튼
    let backBarButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .chevronLeftLarge.withTintColor(.grey800)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        defaultNavBar.itemsHStack.addArrangedSubview(backBarButton)
        defaultNavBar.itemsHStack.addArrangedSubview(UISpacer())
    }
}

// MARK: - Preview

#Preview { BackButtonVC() }
