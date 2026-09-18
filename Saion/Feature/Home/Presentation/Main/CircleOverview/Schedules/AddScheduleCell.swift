//
//  AddScheduleCell.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import Combine
import UIKit

import SnapKit

import DesignSystem

final class AddScheduleCell: UICollectionViewCell {
    
    // MARK: Components
    
    private let mainHStack = UIStackView(
        alignment: .center,
        spacing: 4,
        inset: .init(horizontal: 16, vertical: 20)
    )
    
    private let plusImageView = {
        let view = UIImageView()
        view.image = .plusFill.withTintColor(.gray500)
        view.contentMode = .center
        return view
    }()
    
    private let titleLabel = {
        let style = TextStyle(
            typography: .init(font: .pretendard(size: 16, weight: .medium)),
            decoration: .init(foregroundColor: .gray500)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("일정 추가")
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 고정 상태 셀로, 재사용 필요 없음
    
    // MARK: Defaults
    
    private func setupDefaults() {
        contentView.backgroundColor = .gray0
        contentView.layer.cornerRadius = Radius.componentXxlarge
        contentView.clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainHStack)
        mainHStack.addArrangedSubview(plusImageView)
        mainHStack.addArrangedSubview(titleLabel)
        mainHStack.addArrangedSubview(UISpacer())
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - Preview

#Preview { AddScheduleCell() }
