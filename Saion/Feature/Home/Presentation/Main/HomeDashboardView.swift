//
//  HomeDashboardView.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import UIKit

import SnapKit

import DesignSystem

final class HomeDashboardView: UIStackView {
    
    // MARK: Components
    
    private let titleLabel = {
        let style = TextStyle(
            typography: .title1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        
        let formatter = DateFormatter.seoul
        formatter.dateFormat = "M월 d일 (E)"
        label.text = formatter.string(from: Date())
        
        return label
    }()
    
    private let contentVStack = {
        let view = UIStackView(.vertical)
        view.inset = .init(edges: 20)
        view.backgroundColor = .backgroundDefault
        view.layer.cornerRadius = Radius.containerXlarge
        view.clipsToBounds = true
        return view
    }()
    
    private let idleView = IdleView()
    
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
        axis = .vertical
        spacing = 10
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(contentVStack)
        
        // FIXME: 프리뷰 디버깅용으로 임시로 붙임
        contentVStack.addArrangedSubview(idleView)
    }
}

// MARK: - IdleView

private final class IdleView: UIStackView {
    
    // MARK: Components
    
    private let letterImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = .homeLetter
        return view
    }()
    
    private let descriptionLabel = {
        let style = TextStyle(
            typography: .title1,
            decoration: .init(foregroundColor: .labelDefault),
            paragraph: .init(alignment: .center)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("써클에 함께할 가족을 초대해주세요")
        return label
    }()
    
    let sendInviteButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "초대장 보내기"
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        axis = .vertical
        spacing = 16
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(letterImageView)
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(sendInviteButton)
    }
}

// MARK: - Preview

#Preview { HomeDashboardView() }

