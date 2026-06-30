//
//  UIDivider.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/22/26.
//

import UIKit

public final class UIDivider: UIView {
    
    // MARK: Properties
    
    private let width: CGFloat?
    private let height: CGFloat?
    
    // MARK: Life Cycle
    
    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        color: UIColor
    ) {
        self.width = width
        self.height = height
        super.init(frame: .zero)
        backgroundColor = color
    }
    
    @MainActor public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Intrinsic Content Size
    
    public override var intrinsicContentSize: CGSize {
        CGSize(
            width: width ?? super.intrinsicContentSize.width,
            height: height ?? super.intrinsicContentSize.height
        )
    }
}
 
