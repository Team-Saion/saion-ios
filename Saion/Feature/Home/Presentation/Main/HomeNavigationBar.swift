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
    
    /// 서클 이름을 표시하는 레이블
    let circleLabel = {
        let style = TextStyle(
            typography: .init(
                font: .pretendard(size: 24, weight: .semiBold),
                lineHeight: 25
            ),
            decoration: .init(foregroundColor: .gray900)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    let notificationButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .bell.withTintColor(.gray600)
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
        addArrangedSubview(circleLabel)
        addArrangedSubview(UISpacer())
        addArrangedSubview(notificationButton)
    }
}
