//
//  TextFormAppearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/18/26.
//

import UIKit

struct TextFormAppearance: Equatable {
    var titleColor: UIColor
    var placeholderColor: UIColor
    var textColor: UIColor
    var captionColor: UIColor
    var backgroundColor: UIColor
    var strokeColor: UIColor
    var strokeWidth: CGFloat
    
    /// 베이스 상태
    static let normal = TextFormAppearance(
        titleColor: .labelStrong,
        placeholderColor: .labelMuted,
        textColor: .labelDefault,
        captionColor: .labelSubtle,
        backgroundColor: .fillSubtle,
        strokeColor: .lineSubtle,
        strokeWidth: 1
    )
    
    static var focused: TextFormAppearance {
        var base = TextFormAppearance.normal
        base.strokeColor = .labelStrong
        base.strokeWidth = 1.5
        return base
    }
    
    static var filled: TextFormAppearance {
        TextFormAppearance.normal
    }
    
    static var error: TextFormAppearance {
        var base = TextFormAppearance.normal
        base.titleColor = .statusNegativeDefault
        base.captionColor = .statusNegativeDefault
        base.strokeColor = .statusNegativeDefault
        base.strokeWidth = 1.5
        return base
    }
    
    static var disabled: TextFormAppearance {
        var base = TextFormAppearance.normal
        base.placeholderColor = .labelDisabled
        base.textColor = .labelDisabled
        base.backgroundColor = .fillDisabled
        base.strokeColor = .lineStrong
        return base
    }
}
