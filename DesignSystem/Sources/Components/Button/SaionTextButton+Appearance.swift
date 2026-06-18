//
//  SaionTextButton+Appearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/17/26.
//

import UIKit

extension SaionTextButton {
    public struct Appearance: Sendable {
        public let size: SizeMetrics
        public let variant: Variant
        
        public init(
            size: SizeMetrics,
            variant: Variant
        ) {
            self.size = size
            self.variant = variant
        }
        
        public struct SizeMetrics: Sendable {
            public let typography: TextStyle.Typography
            public let imageSize: CGSize
            
            public init(
                typography: TextStyle.Typography,
                imageSize: CGSize
            ) {
                self.typography = typography
                self.imageSize = imageSize
            }
        }
        
        public struct Variant: Sendable {
            public let foregroundColor: ByState<UIColor>
            public let overlayColor: ByState<UIColor>
            public let image: UIImage?
            
            public init(
                foregroundColor: ByState<UIColor>,
                overlayColor: ByState<UIColor>,
                image: UIImage?
            ) {
                self.foregroundColor = foregroundColor
                self.overlayColor = overlayColor
                self.image = image
            }
        }
        
        public struct ByState<T: Sendable>: Sendable {
            public let normal: T
            public let highlighted: T
            public let disabled: T
            
            public init(
                normal: T,
                highlighted: T,
                disabled: T
            ) {
                self.normal = normal
                self.highlighted = highlighted
                self.disabled = disabled
            }
        }
    }
}

// MARK: - Size Tokens

extension SaionTextButton.Appearance.SizeMetrics {
    public static let large: Self = .init(
        typography: .title1Subtle,
        imageSize: .init(width: 14, height: 14)
    )
    
    public static let medium: Self = .init(
        typography: .body1,
        imageSize: .init(width: 12, height: 12)
    )
    
    public static let small: Self = .init(
        typography: .label1Subtle,
        imageSize: .init(width: 10, height: 10)
    )
}

// MARK: - Variant Tokens

extension SaionTextButton.Appearance.Variant {
    public static let normal: Self = .init(
        foregroundColor: .init(
            normal: .labelStrong,
            highlighted: .labelStrong,
            disabled: .labelDisabled
        ),
        overlayColor: .init(
            normal: .clear,
            highlighted: .overlayPressedSubtle,
            disabled: .clear
        ),
        image: nil
    )
    
    public static let chevron: Self = .init(
        foregroundColor: .init(
            normal: .labelStrong,
            highlighted: .labelStrong,
            disabled: .labelDisabled
        ),
        overlayColor: .init(
            normal: .clear,
            highlighted: .overlayPressedSubtle,
            disabled: .clear
        ),
        image: UIImage(resource: .chevronRightLarge)
    )
}
