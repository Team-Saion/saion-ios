//
//  SaionBadge.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/22/26.
//

import UIKit

open class SaionBadge: InsetAttributedLabel {
    
    // MARK: Properties
    
    open var appearance: SaionBadgeAppearance {
        didSet { updateAppearance() }
    }
    
    open override var intrinsicContentSize: CGSize {
        CGSize(
            width: super.intrinsicContentSize.width,
            height: appearance.sizeMetrics.height
        )
    }
    
    // MARK: Life Cycle
    
    public init(appearance: SaionBadgeAppearance) {
        self.appearance = appearance
        super.init(frame: .zero)
        updateAppearance()
    }
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UpdateAppearance
    
    private func updateAppearance() {
        let style = TextStyle(
            typography: appearance.sizeMetrics.typography,
            decoration: .init(foregroundColor: appearance.foregroundColor)
        )
        textAttributes = style.toDictionary()
        
        inset = appearance.sizeMetrics.inset
        layer.cornerRadius = appearance.sizeMetrics.radius
        clipsToBounds = true
        backgroundColor = appearance.backgroundColor
    }
}
