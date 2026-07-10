//
//  HomeHeaderView.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import UIKit

import SnapKit

import DesignSystem

final class HomeHeaderView: UIView {
    
    // MARK: Components
    
    private let gradientLineView = GradientView()
    
    let titleLabel = {
        let style = TextStyle(
            typography: .label2,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = InsetAttributedLabel()
        label.textAttributes = style.toDictionary()
        label.inset = .init(horizontal: 11)
        
        label.layer.borderColor = UIColor.lineSubtle.cgColor
        label.layer.borderWidth = 1
        
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.backgroundColor = .common0
        
        // FIXME: 임시로 붙임
        label.text = "정욱네"
        
        label.snp.makeConstraints { $0.height.equalTo(32) }
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
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(gradientLineView)
        addSubview(titleLabel)
        
        gradientLineView.snp.makeConstraints { $0.horizontalEdges.centerY.equalToSuperview() }
        titleLabel.snp.makeConstraints { $0.verticalEdges.centerX.equalToSuperview() }
    }
}

// MARK: - GradientView

private final class GradientView: UIView {
    
    // MARK: Properties
    
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.lineDefault.cgColor,
            UIColor.lineDefault.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.2981, 0.7019, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
