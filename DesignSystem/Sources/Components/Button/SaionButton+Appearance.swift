//
//  SaionButton+Appearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/17/26.
//

import UIKit

extension SaionButton {
    public struct Appearance: Sendable {
        public let size: SizeMetrics
        public let variant: Variant
        
        public var image: UIImage?
        public var imagePlacement: NSDirectionalRectEdge = .leading
        
        public init(
            size: SizeMetrics,
            variant: Variant,
            image: UIImage? = nil,
            imagePlacement: NSDirectionalRectEdge = .leading
        ) {
            self.size = size
            self.variant = variant
            self.image = image
            self.imagePlacement = imagePlacement
        }
        
        public struct SizeMetrics: Sendable {
            public let typography: TextStyle.Typography
            public let contentInset: NSDirectionalEdgeInsets
            public let height: CGFloat
            
            public init(
                typography: TextStyle.Typography,
                contentInset: NSDirectionalEdgeInsets,
                height: CGFloat
            ) {
                self.typography = typography
                self.contentInset = contentInset
                self.height = height
            }
        }
        
        public struct Variant: Sendable {
            public let foregroundColor: UIColor
            public let backgroundColor: UIColor
            
            public init(
                foregroundColor: UIColor,
                backgroundColor: UIColor
            ) {
                self.foregroundColor = foregroundColor
                self.backgroundColor = backgroundColor
            }
        }
    }
}

// MARK: Size Tokens

extension SaionButton.Appearance.SizeMetrics {
    public static let small: Self = .init(
        typography: .label2,
        contentInset: .init(horizontal: 13),
        height: 32
    )
    
    public static let medium: Self = .init(
        typography: .label1Subtle,
        contentInset: .init(horizontal: 17),
        height: 40
    )
    
    public static let large: Self = .init(
        typography: .body1,
        contentInset: .init(horizontal: 20),
        height: 48
    )
    
    public static let xlarge: Self = .init(
        typography: .title1Subtle,
        contentInset: .init(horizontal: 24),
        height: 57
    )
}

// MARK: Variant Tokens

extension SaionButton.Appearance.Variant {
    public static let primary: Self = .init(
        foregroundColor: .labelInverse,
        backgroundColor: .primaryDefault
    )
    
    public static let subtle: Self = .init(
        foregroundColor: .labelInverse,
        backgroundColor: .primarySubtle
    )
    
    public static let neutral: Self = .init(
        foregroundColor: .labelStrong,
        backgroundColor: .fillDefault
    )
    
    public static let danger: Self = .init(
        foregroundColor: .labelInverse,
        backgroundColor: .statusNegativeDefault
    )
}
