//
//  BottomSheetAnimatedTransitioning.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/23/26.
//

import UIKit

final class BottomSheetAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: AnimationType
    
    enum AnimationType { case present, dismiss }
    
    // MARK: Properties
    
    private let animationType: AnimationType
    
    // MARK: Life Cycle
    
    init(_ animationType: AnimationType) {
        self.animationType = animationType
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    /// 애니메이션 지속 시간 설정
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        switch animationType {
        case .present: return 0.4
        case .dismiss: return 0.25
        }
    }
    
    /// 실제 애니메이션 설정
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        switch animationType {
        case .present: animatePresentation(transitionContext)
        case .dismiss: animateDismissal(transitionContext)
        }
    }
    
    // MARK: Private Helpers
    
    /// 실제 슬라이드 애니메이션은 PresentationController에서 처리함
    private func animatePresentation(
        _ context: UIViewControllerContextTransitioning
    ) {
        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: .zero,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            // no-op
        } completion: { finished in
            context.completeTransition(finished && !context.transitionWasCancelled)
        }
    }
    
    private func animateDismissal(
        _ context: UIViewControllerContextTransitioning
    ) {
        guard let view = context.view(forKey: .from)
        else { context.completeTransition(false); return }
        
        // 실제 슬라이드 애니메이션은 PresentationController에서 처리함
        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: .zero,
            options: .curveEaseIn
        ) {
            // no-op
        } completion: { finished in
            view.removeFromSuperview()
            context.completeTransition(finished && !context.transitionWasCancelled)
        }
    }
}
