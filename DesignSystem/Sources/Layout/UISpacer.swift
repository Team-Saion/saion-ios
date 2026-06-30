//
//  UISpacer.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/22/26.
//

import UIKit

public final class UISpacer: UIView {
    
    // MARK: Properties
    
    private let spacing: CGFloat?
    
    // MARK: Life Cycle
    
    public init(_ spacing: CGFloat? = nil) {
        self.spacing = spacing
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Intrinsic Content Size
    
    public override var intrinsicContentSize: CGSize {
        if let spacing {
            return CGSize(width: spacing, height: spacing)
        } else {
            return super.intrinsicContentSize
        }
    }
}
