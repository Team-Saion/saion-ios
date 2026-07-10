//
//  SaionPlainTextFieldAppearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/9/26.
//

import UIKit

struct SaionPlainTextFieldAppearance: TextFieldAppearance {
    var placeholderColor: UIColor
    var textColor: UIColor
    
    static func appearance(for state: TextFieldState) -> SaionPlainTextFieldAppearance {
        // normal 상태를 베이스로 두고, 상태별로 필요한 값만 변형
        var appearance = SaionPlainTextFieldAppearance(
            placeholderColor: .labelMuted,
            textColor: .labelDefault
        )
        
        switch state {
        case .normal, .focused:
            break
            
        case .filled:
            appearance.textColor = .labelStrong
            
        case .error:
            appearance.placeholderColor = .statusNegativeDefault
            appearance.textColor = .statusNegativeDefault
            
        case .disabled:
            appearance.placeholderColor = .labelDisabled
            appearance.textColor = .labelDisabled
        }
        
        return appearance
    }
}
