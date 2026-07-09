//
//  HomeNavigationBar.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import UIKit

import DesignSystem

final class HomeNavigationBar: UIStackView {
    
    // MARK: Components
    
    private let logoImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = .homeLogo.withTintColor(.grey400)
        return view
    }()
    
    let notificationButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .bell.withTintColor(.grey400)
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(leading: 20, trailing: 8)
        alignment = .center
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(logoImageView)
        addArrangedSubview(UISpacer())
        addArrangedSubview(notificationButton)
    }
}
