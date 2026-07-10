//
//  SaionLineTextFieldAppearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/9/26.
//

import UIKit

struct SaionLineTextFieldAppearance: TextFieldAppearance {
    var placeholderColor: UIColor
    var textColor: UIColor
    var underlineColor: UIColor
    var underlineWidth: CGFloat
    
    static func appearance(for state: TextFieldState) -> SaionLineTextFieldAppearance {
        // normal 상태를 베이스로 두고, 상태별로 필요한 값만 변형
        var appearance = SaionLineTextFieldAppearance(
            placeholderColor: .labelMuted,
            textColor: .labelDefault,
            underlineColor: .lineSubtle,
            underlineWidth: 1
        )
        
        switch state {
        case .normal, .filled:
            break
            
        case .focused:
            appearance.underlineColor = .labelStrong
            appearance.underlineWidth = 1.5
            
        case .error:
            appearance.underlineColor = .statusNegativeDefault
            appearance.underlineWidth = 1.5
            
        case .disabled:
            appearance.placeholderColor = .labelDisabled
            appearance.textColor = .labelDisabled
            appearance.underlineColor = .lineStrong
        }
        
        return appearance
    }
}
