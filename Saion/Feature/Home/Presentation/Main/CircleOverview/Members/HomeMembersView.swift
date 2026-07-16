//
//  HomeMembersView.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import UIKit

import DesignSystem

final class HomeMembersView: UIStackView {
    
    // MARK: Components
    
    private let headerHStack = UIStackView(alignment: .center, inset: .init(horizontal: 20))
    
    private let headerLabel = {
        let style = TextStyle(
            typography: .title1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("구성원")
        return label
    }()
    
    let showAllButton = {
        var variant = SaionTextButton.Appearance.Variant.normal
        variant.foregroundColor.normal = .labelSubtle
        variant.foregroundColor.highlighted = .labelSubtle
        let appearance = SaionTextButton.Appearance(size: .small, variant: variant)
        let button = SaionTextButton(with: appearance)
        button.title = "전체 보기"
        return button
    }()
    
    let collectionView = HomeMembersCollectionView()
    
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
        spacing = 12
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(headerHStack)
        addArrangedSubview(collectionView)
        
        headerHStack.addArrangedSubview(headerLabel)
        headerHStack.addArrangedSubview(UISpacer())
        headerHStack.addArrangedSubview(showAllButton)
    }
}
