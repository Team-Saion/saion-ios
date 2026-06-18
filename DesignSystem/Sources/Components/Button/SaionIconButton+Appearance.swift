//
//  SaionIconButton+Appearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/18/26.
//

import Foundation

extension SaionIconButton {
    public struct Appearance: Sendable {
        public let size: SizeMetrics
        
        public init(size: SizeMetrics) {
            self.size = size
        }
        
        public struct SizeMetrics: Sendable {
            public let buttonSize: CGSize
            public let imageSize: CGSize
            
            public init(
                buttonSize: CGSize,
                imageSize: CGSize
            ) {
                self.buttonSize = buttonSize
                self.imageSize = imageSize
            }
        }
    }
}

// MARK: - Size Tokens

extension SaionIconButton.Appearance.SizeMetrics {
    public static let large: Self = .init(
        buttonSize: CGSize(width: 44, height: 44),
        imageSize: CGSize(width: 24, height: 24)
    )
    
    public static let medium: Self = .init(
        buttonSize: CGSize(width: 36, height: 36),
        imageSize: CGSize(width: 20, height: 20)
    )
    
    public static let small: Self = .init(
        buttonSize: CGSize(width: 28, height: 28),
        imageSize: CGSize(width: 16, height: 16)
    )
}

