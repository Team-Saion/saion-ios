//
//  InviteMemberCell.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import UIKit

import DesignSystem

import SnapKit

final class InviteMemberCell: UICollectionViewCell {
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, alignment: .center, spacing: 8)
    
    private let plusImageView = {
        let view = UIImageView()
        view.image = .homePlusDashedCircle
        view.contentMode = .center
        return view
    }()
    
    private let nameLabel = {
        let style = TextStyle(
            typography: .label1Subtle,
            decoration: .init(foregroundColor: .labelSubtle)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("가족 초대")
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 고정 상태 셀로, 재사용 필요 없음
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(plusImageView)
        mainVStack.addArrangedSubview(nameLabel)
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
