//
//  AttributedLabel.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/18/26.
//

import UIKit

/// 기본 텍스트 스타일을 적용하는 UILabel
open class AttributedLabel: UILabel {
    
    // MARK: Properties
    
    /// 기본 텍스트 속성
    /// - 값이 변경되면 현재 텍스트에 다시 적용됨
    open var textAttributes = [NSAttributedString.Key: Any]() {
        didSet { setAttributedText(with: text) }
    }
    
    /// 일반 텍스트를 설정하면 기본 속성을 적용해 attributedText로 변환
    open override var text: String? {
        get { attributedText?.string }
        set { setAttributedText(with: newValue) }
    }
    
    // MARK: Private Helpers
    
    /// 문자열에 기본 텍스트 속성을 적용해 attributedText 갱신
    private func setAttributedText(with text: String?) {
        attributedText = text.map {
            NSAttributedString(string: $0, attributes: textAttributes)
        }
    }
}
