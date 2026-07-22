//
//  DDayBadge.swift
//  Saion
//
//  Created by 신정욱 on 7/22/26.
//

import UIKit

import DesignSystem

final class DDayBadge: SaionBadge {
    
    // MARK: Configure
    
    func configure(with state: DDayBadgeState) {
        appearance.foregroundColor = state.foregroundColor
        appearance.backgroundColor = state.backgroundColor
        text = state.text
    }
}

// MARK: - Presentation Model

struct DDayBadgeState: Hashable {
    let foregroundColor: UIColor
    let backgroundColor: UIColor
    let text: String
    
    init(dDay: Int?) {
        var foregroundColor: UIColor = .labelSubtle
        var backgroundColor: UIColor = .grey100
        var text = "종료"
        
        if let dDay {
            if dDay <= 7 {
                foregroundColor = .red600
                backgroundColor = .red50
            }
            text = "\(dDay)일 전"
        }
        
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.text = text
    }
}
