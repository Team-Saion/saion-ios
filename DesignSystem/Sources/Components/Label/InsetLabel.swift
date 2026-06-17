//
//  InsetLabel.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/17/26.
//

import UIKit

open class InsetLabel: UILabel {
    
    // MARK: Properties
    
    open var inset: UIEdgeInsets = .zero {
        didSet {
            // 크기 변경을 시스템에 알림
            invalidateIntrinsicContentSize()
            // 텍스트 다시 그리기 요청
            setNeedsDisplay()
        }
    }
    
    // MARK: Overrides
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += inset.top + inset.bottom
        contentSize.width += inset.left + inset.right
        return contentSize
    }
}
