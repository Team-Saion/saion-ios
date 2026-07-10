//
//  AttributedTextField.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/18/26.
//

import UIKit

open class AttributedTextField: DefaultTextField {
    
    // MARK: Properties
    
    /// 기본 텍스트 속성
    open override var defaultTextAttributes: [NSAttributedString.Key : Any] {
        // 속성 변경에 따른 스타일 유실을 방지하기 위해 속성 재적용 처리
        didSet { setAttributedText(with: text) }
    }
    
    /// 기본 플레이스홀더 속성
    open var placeholderAttributes = [NSAttributedString.Key: Any]() {
        didSet { setAttributedPlaceholder(with: placeholder) }
    }
    
    /// 일반 플레이스홀더를 설정하면 기본 속성을 적용해 attributedText로 변환
    open override var placeholder: String? {
        get { attributedPlaceholder?.string }
        set { setAttributedPlaceholder(with: newValue) }
    }
    
    // MARK: Private Helpers
    
    /// 문자열에 기본 플레이스홀더 속성을 적용해 attributedText 갱신
    private func setAttributedPlaceholder(with text: String?) {
        attributedPlaceholder = text.map {
            NSAttributedString(string: $0, attributes: placeholderAttributes)
        }
    }
    
    /// 텍스트에 기본 속성을 적용해 attributedText 갱신
    private func setAttributedText(with text: String?) {
        attributedText = text.map {
            NSAttributedString(string: $0, attributes: defaultTextAttributes)
        }
    }
}
