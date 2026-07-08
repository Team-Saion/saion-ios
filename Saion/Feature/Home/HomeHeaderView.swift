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
    
    private let titleHStack = {
        let makeHearImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            view.image = .heartFill.withTintColor(.labelStrong)
            
            view.snp.makeConstraints { $0.size.equalTo(14) }
            return view
        }
        
        let view = UIStackView()
        view.inset = .init(horizontal: 11)
        view.alignment = .center
        view.spacing = 4
        
        view.layer.borderColor = UIColor.lineSubtle.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .common0
        
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        view.addArrangedSubview(makeHearImageView())
        view.addArrangedSubview(makeHearImageView())
        
        view.snp.makeConstraints { $0.height.equalTo(32) }
        return view
    }()
    
    let titleLabel = {
        let style = TextStyle(
            typography: .label2,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        // FIXME: 임시로 붙임
        label.text = "정욱네"
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
        addSubview(titleHStack)
        
        titleHStack.insertArrangedSubview(titleLabel, at: 1)
        
        gradientLineView.snp.makeConstraints { $0.horizontalEdges.centerY.equalToSuperview() }
        titleHStack.snp.makeConstraints { $0.verticalEdges.centerX.equalToSuperview() }
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
