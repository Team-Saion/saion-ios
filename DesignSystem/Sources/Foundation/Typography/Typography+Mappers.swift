//
//  Typography+Mappers.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/11/26.
//

import UIKit
import SwiftUI

public extension Typography {
    /// 현재 설정된 텍스트 속성들을 기반으로 NSAttributedString용 속성 딕셔너리 생성
    func toDictionary() -> [NSAttributedString.Key: Any] {
        /// 문단 스타일
        let paragraphStyle = NSMutableParagraphStyle()
        /// 속성 딕셔너리
        var attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font
        ]
        
        // paragraphStyle의 속성들을 설정 (옵셔널 맵)
        paragraphSpacing.map { paragraphStyle.paragraphSpacing = $0 }
        alignment.map { paragraphStyle.alignment = $0 }
        lineBreakMode.map { paragraphStyle.lineBreakMode = $0 }
        lineBreakStrategy.map { paragraphStyle.lineBreakStrategy = $0 }
        
        // attributes 딕셔너리에 값 직접 대입 (nil을 대입하면 해당 속성은 적용되지 않음)
        attributes[.foregroundColor] = foregroundColor
        attributes[.underlineStyle] = underlineStyle?.rawValue
        attributes[.underlineColor] = underlineColor
        attributes[.kern] = letterSpacing?.rawValue
        
        // 행 높이(Line Height) 설정 및 베이스라인 오프셋 계산
        if let lineHeight {
            paragraphStyle.minimumLineHeight = lineHeight.rawValue
            paragraphStyle.maximumLineHeight = lineHeight.rawValue
            attributes[.baselineOffset] = (lineHeight.rawValue - font.lineHeight) / 2
        }
        
        return attributes
    }
    
    /// 설정된 속성들을 기반으로 AttributeContainer 생성
    func toContainer() -> AttributeContainer {
        AttributeContainer(toDictionary())
    }
    
    /// 설정된 속성들을 기반으로 NSAttributedString 생성
    func toNSAttributedString(_ text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: toDictionary())
    }
    
    /// 설정된 속성들을 기반으로 AttributedString 생성
    func toAttributedString(_ text: String) -> AttributedString {
        AttributedString(text, attributes: toContainer())
    }
}
