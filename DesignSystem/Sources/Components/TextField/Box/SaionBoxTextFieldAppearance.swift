//
//  SaionBoxTextFieldAppearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/9/26.
//

import UIKit

struct SaionBoxTextFieldAppearance: TextFieldAppearance {
    var placeholderColor: UIColor
    var textColor: UIColor
    var backgroundColor: UIColor
    var strokeColor: UIColor
    var strokeWidth: CGFloat
    
    static func appearance(for state: TextFieldState) -> SaionBoxTextFieldAppearance {
        // normal 상태를 베이스로 두고, 상태별로 필요한 값만 변형
        var appearance = SaionBoxTextFieldAppearance(
            placeholderColor: .labelMuted,
            textColor: .labelDefault,
            backgroundColor: .fillSubtle,
            strokeColor: .lineSubtle,
            strokeWidth: 1
        )
        
        switch state {
        case .normal, .filled:
            break
            
        case .focused:
            appearance.strokeColor = .labelStrong
            appearance.strokeWidth = 1.5
            
        case .error:
            appearance.strokeColor = .statusNegativeDefault
            appearance.strokeWidth = 1.5
            
        case .disabled:
            appearance.placeholderColor = .labelDisabled
            appearance.textColor = .labelDisabled
            appearance.backgroundColor = .fillDisabled
            appearance.strokeColor = .lineStrong
        }
        
        return appearance
    }
}
