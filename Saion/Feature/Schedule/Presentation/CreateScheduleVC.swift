//
//  CreateScheduleVC.swift
//  Saion
//
//  Created by 신정욱 on 7/9/26.
//

import UIKit

import SnapKit

import DesignSystem
import Navigation

final class CreateScheduleVC: NavigationBarVC {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let closeButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .xBold
        return button
    }()
    
    private let nameTextField = {
        let field = SaionBoxTextField()
        return field
    }
    
    // MARK: Life Cycle
    
    
    // MARK: Defaults
    
    private func setupDefaults() {
        defaultNavBar.titleLabel.text = "일정 추가"
    }
    
    // MARK: Layout
    
    private func setupLayout() {}
    
    // MARK: Bindings
    
    private func setupBindings() {}
}
