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
    
    private let dashedStrokeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lineDefault.cgColor
        layer.lineDashPattern = [10, 8]
        layer.lineWidth = 1.5
        return layer
    }()
    
    private let mainHStack = UIStackView(
        alignment: .center,
        inset: .init(horizontal: 16, vertical: 20)
    )
    
    private let plusImageView = {
        let view = UIImageView()
        view.image = .plusFill.withTintColor(.grey300)
        view.contentMode = .center
        return view
    }()
    
    private let titleLabel = {
        let style = TextStyle(
            typography: .title2,
            decoration: .init(foregroundColor: .labelSubtle)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedStrokeLayer.path = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: Radius.componentXxlarge
        ).cgPath
    }
    
    // 고정 상태 셀로, 재사용 필요 없음
    
    // MARK: Defaults
    
    private func setupDefaults() {
        contentView.backgroundColor = .backgroundSubtle
        contentView.layer.cornerRadius = Radius.componentXxlarge
        contentView.clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.layer.addSublayer(dashedStrokeLayer)
        contentView.addSubview(mainHStack)
        
        mainHStack.addArrangedSubview(plusImageView)
        mainHStack.addArrangedSubview(titleLabel)
        mainHStack.addArrangedSubview(UISpacer())
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
