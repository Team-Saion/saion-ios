//
//  CircleNameFormAppearance.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import UIKit

import DesignSystem

struct CircleNameFormAppearance: Equatable {
    var textColor: UIColor
    var captionColor: UIColor
    
    /// 베이스 상태
    static let normal = CircleNameFormAppearance(
        textColor: .labelDefault,
        captionColor: .labelSubtle
    )
    
    static var focused: CircleNameFormAppearance {
        CircleNameFormAppearance.normal
    }
    
    static var filled: CircleNameFormAppearance {
        var base = CircleNameFormAppearance.normal
        base.textColor = .labelStrong
        return base
    }
    
    static var error: CircleNameFormAppearance {
        var base = CircleNameFormAppearance.normal
        base.textColor = .statusNegativeDefault
        base.captionColor = .statusNegativeDefault
        return base
    }
}
