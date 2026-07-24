//
//  InboxCell.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import UIKit

import SnapKit

import DesignSystem

final class InboxCell: UICollectionViewCell {
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, spacing: 2, inset: .init(edges: 16))
    private let titleHStack = UIStackView(alignment: .top)
    
    private let titleLabel = {
        let style = TextStyle(
            typography: .title3Strong,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    private let dateLabel = {
        let style = TextStyle(
            typography: .caption2,
            decoration: .init(foregroundColor: .labelSubtle)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    private let captionLabel = {
        let style = TextStyle(
            typography: .caption1,
            decoration: .init(foregroundColor: .labelSubtle)
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
        contentView.addSubview(mainVStack)
        mainVStack.addArrangedSubview(titleHStack)
        mainVStack.addArrangedSubview(captionLabel)
        
        titleHStack.addArrangedSubview(titleLabel)
        titleHStack.addArrangedSubview(dateLabel)
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configure
    
    func configure(with item: InboxCellItem?) {
        titleLabel.text = item?.title
        dateLabel.text = item?.date
        captionLabel.text = item?.caption
    }
}

// MARK: - Presentation Model

struct InboxCellItem: Hashable {
    let title: String
    let date: String
    let caption: String
}
