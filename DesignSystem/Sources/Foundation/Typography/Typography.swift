//
//  Typography.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/11/26.
//

import UIKit

/// AttributedString을 구성하는 텍스트 속성 정의
public struct Typography: Sendable {
    /// 적용할 폰트 (기본값은 본문용 preferredFont)
    public var font: UIFont = .preferredFont(forTextStyle: .body)
    /// 텍스트 색상
    public var foregroundColor: UIColor?
    /// 텍스트 정렬 방식 (기본값은 .natural)
    public var alignment: NSTextAlignment? = .natural
    /// 줄 높이 (행간)
    public var lineHeight: LineHeight?
    /// 자간 (글자 간격)
    public var letterSpacing: LetterSpacing?
    /// 문단 간의 간격
    public var paragraphSpacing: CGFloat?
    /// 밑줄 스타일
    public var underlineStyle: NSUnderlineStyle?
    /// 밑줄 색상
    public var underlineColor: UIColor?
    /// 줄바꿈 기준 모드 (기본값은 .byTruncatingTail)
    /// - Important: UITextView에서는 .byTruncatingTail 적용 시 개행 처리가 되지 않는 경우가 있음
    public var lineBreakMode: NSLineBreakMode? = .byTruncatingTail
    /// 한글 단어 단위 줄바꿈 등의 줄바꿈 전략 (기본값은 .hangulWordPriority)
    public var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy? = .hangulWordPriority
}
