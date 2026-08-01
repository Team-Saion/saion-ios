//
//  DDayBadge.swift
//  Saion
//
//  Created by 신정욱 on 7/22/26.
//

import UIKit

import DesignSystem

final class DDayBadge: SaionBadge {
    
    // MARK: Life Cycle
    
    override init(appearance: SaionBadgeAppearance) {
        super.init(appearance: appearance)
        setupLayout()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: Configure
    
    func configure(with state: DDayBadgeState?) {
        appearance.foregroundColor = state?.foregroundColor
        appearance.backgroundColor = state?.backgroundColor
        text = state?.title
    }
}

// MARK: - Presentation Model

struct DDayBadgeState: Hashable {
    let foregroundColor: UIColor
    let backgroundColor: UIColor
    let title: String
    
    init(status: ScheduleStatus) {
        var foregroundColor: UIColor = .labelSubtle
        var backgroundColor: UIColor = .grey100
        let title: String
        
        switch status {
        case .upcoming(let dDay?):
            title = "\(dDay)일 전"
            
            if dDay <= 7 {
                foregroundColor = .red600
                backgroundColor = .red50
            }
            
        case .upcoming(nil):
            title = "시작 전"
            
        case .inProgress:
            title = "진행중"
            
        case .completed:
            title = "완료"
        }
        
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.title = title
    }
}
