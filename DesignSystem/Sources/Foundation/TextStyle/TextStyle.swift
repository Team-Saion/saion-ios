//
//  TextStyle.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/11/26.
//

import UIKit

/// 구조화된 형태의 텍스트 속성 정의
public struct TextStyle: Sendable {
    
    // MARK: Properties
    
    /// 서체 및 텍스트 레이아웃 관련 속성
    public var typography: Typography
    /// 텍스트 데코레이션(색상, 밑줄 등) 관련 속성
    public var decoration: Decoration
    /// 문단 스타일(정렬, 줄바꿈 등) 관련 속성
    public var paragraph: Paragraph
    
    public init(
        typography: Typography = .init(),
        decoration: Decoration = .init(),
        paragraph: Paragraph = .init()
    ) {
        self.typography = typography
        self.decoration = decoration
        self.paragraph = paragraph
    }
    
    // MARK: Typography
    
    /// 서체 및 레이아웃 관련 속성 정의
    public struct Typography: Sendable {
        /// 적용할 폰트
        public var font: UIFont?
        /// 줄 높이 (행간)
        public var lineHeight: LineHeight?
        /// 자간 (글자 간격)
        public var letterSpacing: LetterSpacing?
        
        public init(
            font: UIFont? = nil,
            lineHeight: LineHeight? = nil,
            letterSpacing: LetterSpacing? = nil
        ) {
            self.font = font
            self.lineHeight = lineHeight
            self.letterSpacing = letterSpacing
        }
    }
    
    // MARK: Decoration
    
    /// 텍스트 시각 효과 관련 속성 정의
    public struct Decoration: Sendable {
        /// 텍스트 색상
        public var foregroundColor: UIColor?
        /// 밑줄 스타일
        public var underlineStyle: NSUnderlineStyle?
        /// 밑줄 색상
        public var underlineColor: UIColor?
        
        public init(
            foregroundColor: UIColor? = nil,
            underlineStyle: NSUnderlineStyle? = nil,
            underlineColor: UIColor? = nil
        ) {
            self.foregroundColor = foregroundColor
            self.underlineStyle = underlineStyle
            self.underlineColor = underlineColor
        }
    }
    
    // MARK: Paragraph
    
    /// 문단 레이아웃 관련 속성 정의
    public struct Paragraph: Sendable {
        /// 텍스트 정렬 방식
        public var alignment: NSTextAlignment?
        /// 줄바꿈 기준 모드
        /// - Important: UITextView에서는 .byTruncatingTail 적용 시 개행 처리가 되지 않는 경우가 있음
        public var lineBreakMode: NSLineBreakMode?
        /// 한글 단어 단위 줄바꿈 등의 줄바꿈 전략
        public var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy?
        /// 문단 간의 간격
        public var paragraphSpacing: CGFloat?
        
        public init(
            alignment: NSTextAlignment? = nil,
            lineBreakMode: NSLineBreakMode? = nil,
            lineBreakStrategy: NSParagraphStyle.LineBreakStrategy? = nil,
            paragraphSpacing: CGFloat? = nil
        ) {
            self.alignment = alignment
            self.lineBreakMode = lineBreakMode
            self.lineBreakStrategy = lineBreakStrategy
            self.paragraphSpacing = paragraphSpacing
        }
    }
}
