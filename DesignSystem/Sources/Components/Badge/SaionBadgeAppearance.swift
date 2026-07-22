//
//  SaionBadgeAppearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/22/26.
//

import UIKit

public struct SaionBadgeAppearance {
    public let sizeMetrics: SizeMetrics
    public var foregroundColor: UIColor
    public var backgroundColor: UIColor
    
    public init(
        sizeMetrics: SizeMetrics,
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.sizeMetrics = sizeMetrics
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    public struct SizeMetrics {
        public let typography: TextStyle.Typography
        public let height: CGFloat
        public let inset: UIEdgeInsets
        public var radius: CGFloat { height / 2 }
        
        public init(
            typography: TextStyle.Typography,
            height: CGFloat,
            inset: UIEdgeInsets
        ) {
            self.typography = typography
            self.height = height
            self.inset = inset
        }
    }
}

extension SaionBadgeAppearance.SizeMetrics {
    public static let large: Self = .init(
        typography: .label1,
        height: 28,
        inset: .init(horizontal: 8)
    )
    
    public static let medium: Self = .init(
        typography: .label2,
        height: 23,
        inset: .init(horizontal: 6)
    )
    
    public static let small: Self = .init(
        typography: .caption2Strong,
        height: 18,
        inset: .init(horizontal: 5)
    )
}
