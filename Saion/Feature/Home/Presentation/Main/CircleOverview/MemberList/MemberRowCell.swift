//
//  MemberRowCell.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import UIKit

import DesignSystem

import SnapKit

final class MemberRowCell: UICollectionViewCell {
    
    // MARK: Components
    
    private let mainHStack = UIStackView(alignment: .center, spacing: 12)
    
    private let profileImageView = ProfileImageView(size: .small)
    
    private let nameLabel = {
        let style = TextStyle(
            typography: .title1Strong,
            decoration: .init(foregroundColor: .grey900)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainHStack)
        
        mainHStack.addArrangedSubview(profileImageView)
        mainHStack.addArrangedSubview(nameLabel)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configure
    
    func configure(with item: MemberCellItem?) {
        if let profileImageViewState = item?.profileImageViewState {
            profileImageView.configure(with: profileImageViewState)
        }
        nameLabel.text = item?.name
    }
}
