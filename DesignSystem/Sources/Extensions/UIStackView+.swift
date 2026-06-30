//
//  UIStackView+.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/22/26.
//

import UIKit

extension UIStackView {
    public convenience init(
        _ axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0,
        inset: NSDirectionalEdgeInsets? = nil
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        
        if let inset {
            self.isLayoutMarginsRelativeArrangement = true
            self.insetsLayoutMarginsFromSafeArea = false // 세이프에어리어 자동 합산 끔
            self.directionalLayoutMargins = inset
        }
    }
    
    public var inset: NSDirectionalEdgeInsets {
        get { self.directionalLayoutMargins }
        set {
            self.isLayoutMarginsRelativeArrangement = true
            self.insetsLayoutMarginsFromSafeArea = false // 세이프에어리어 자동 합산 끔
            self.directionalLayoutMargins = newValue
        }
    }
}
