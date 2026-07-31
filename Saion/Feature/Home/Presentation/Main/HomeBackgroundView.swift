//
//  HomeBackgroundView.swift
//  Saion
//
//  Created by 신정욱 on 7/31/26.
//

import UIKit

import DesignSystem

final class HomeBackgroundView: UIView {
    
    // MARK: Properties
    
    private let gradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.yellow50.cgColor,
            UIColor.backgroundMuted.cgColor
        ]
        layer.locations = [0.0, 0.5962]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
