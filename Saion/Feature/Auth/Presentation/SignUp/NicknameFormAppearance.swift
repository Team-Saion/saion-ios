//
//  NicknameFormAppearance.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

import UIKit

import DesignSystem

struct NicknameFormAppearance: Equatable {
    var textColor: UIColor
    var captionColor: UIColor
    
    /// 베이스 상태
    static let normal = NicknameFormAppearance(
        textColor: .labelDefault,
        captionColor: .labelSubtle
    )
    
    static var focused: NicknameFormAppearance {
        NicknameFormAppearance.normal
    }
    
    static var filled: NicknameFormAppearance {
        var base = NicknameFormAppearance.normal
        base.textColor = .labelStrong
        return base
    }
    
    static var error: NicknameFormAppearance {
        var base = NicknameFormAppearance.normal
        base.textColor = .statusNegativeDefault
        base.captionColor = .statusNegativeDefault
        return base
    }
}
