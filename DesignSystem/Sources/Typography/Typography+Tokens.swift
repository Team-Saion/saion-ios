//
//  Typography+Tokens.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/12/26.
//

import Foundation

extension Typography {
    
    // MARK: FontWeight
    
    public enum FontWeight: String, CaseIterable, Sendable {
        case black      = "Pretendard-Black"
        case bold       = "Pretendard-Bold"
        case extraBold  = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light      = "Pretendard-Light"
        case medium     = "Pretendard-Medium"
        case regular    = "Pretendard-Regular"
        case semiBold   = "Pretendard-SemiBold"
        case thin       = "Pretendard-Thin"
    }
    
    // MARK: FontSize
    
    public struct FontSize:
        RawRepresentable,
        ExpressibleByIntegerLiteral,
        ExpressibleByFloatLiteral,
        Hashable,
        Sendable
    {
        public let rawValue: CGFloat
        
        public init(rawValue: CGFloat) {
            self.rawValue = rawValue
        }
        
        public init(floatLiteral value: Double) {
            self.rawValue = CGFloat(value)
        }
        
        public init(integerLiteral value: Int) {
            self.rawValue = CGFloat(value)
        }
        
        public static let size11: FontSize = 11.0
        public static let size12: FontSize = 12.0
        public static let size13: FontSize = 13.0
        public static let size14: FontSize = 14.0
        public static let size15: FontSize = 15.0
        public static let size16: FontSize = 16.0
        public static let size18: FontSize = 18.0
        public static let size20: FontSize = 20.0
        public static let size24: FontSize = 24.0
        public static let size32: FontSize = 32.0
        public static let size40: FontSize = 40.0
    }
    
    // MARK: LineHeight
    
    public struct LineHeight:
        RawRepresentable,
        ExpressibleByIntegerLiteral,
        ExpressibleByFloatLiteral,
        Hashable,
        Sendable
    {
        public let rawValue: CGFloat
        
        public init(rawValue: CGFloat) {
            self.rawValue = rawValue
        }
        
        public init(floatLiteral value: Double) {
            self.rawValue = CGFloat(value)
        }
        
        public init(integerLiteral value: Int) {
            self.rawValue = CGFloat(value)
        }
        
        public static let height16: LineHeight = 16.0
        public static let height17: LineHeight = 17.0
        public static let height20: LineHeight = 20.0
        public static let height21: LineHeight = 21.0
        public static let height22: LineHeight = 22.0
        public static let height24: LineHeight = 24.0
        public static let height25: LineHeight = 25.0
        public static let height28: LineHeight = 28.0
        public static let height31: LineHeight = 31.0
        public static let height40: LineHeight = 40.0
        public static let height48: LineHeight = 48.0
    }
    
    // MARK: LetterSpacing
    
    public struct LetterSpacing:
        RawRepresentable,
        ExpressibleByIntegerLiteral,
        ExpressibleByFloatLiteral,
        Hashable,
        Sendable
    {
        public let rawValue: CGFloat
        
        public init(rawValue: CGFloat) {
            self.rawValue = rawValue
        }
        
        public init(floatLiteral value: Double) {
            self.rawValue = CGFloat(value)
        }
        
        public init(integerLiteral value: Int) {
            self.rawValue = CGFloat(value)
        }
        
        public static let tighter: LetterSpacing = -1.0
        public static let tight: LetterSpacing = -0.5
        public static let normal: LetterSpacing = 0.0
        public static let wide: LetterSpacing = 0.5
        public static let wider: LetterSpacing = 1.0
        public static let widest: LetterSpacing = 2.0
    }
}
