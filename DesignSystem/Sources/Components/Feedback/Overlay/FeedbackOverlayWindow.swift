//
//  FeedbackOverlayWindow.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import UIKit

public final class FeedbackOverlayWindow: UIWindow {
    
    // MARK: Properties
    
    public override var canBecomeKey: Bool { false }
    
    // MARK: Life Cycle
    
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        rootViewController = FeedbackOverlayHostVC()
        windowLevel = .normal + 1
        backgroundColor = .clear
        isOpaque = false
        isHidden = false
    }
    
    // MARK: Hit Test
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView === rootViewController?.view { return nil }
        
        return hitView
    }
}
