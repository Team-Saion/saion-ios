//
//  AlertPresentationVC.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/30/26.
//

import UIKit

import SnapKit

open class AlertPresentationVC: UIViewController {
    
    // MARK: Life Cycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // 커스텀 프레젠테이션 관련 설정은 반드시 init 내부나 객체 생성 직후 present를 호출하기 전에 해야 함.
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AlertPresentationVC: UIViewControllerTransitioningDelegate {
    /// 프레젠테이션 컨트롤러 설정
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        AlertPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    /// 화면이 나타날 때 사용할 애니메이터 설정
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        AlertAnimatedTransitioning(.present)
    }
    
    /// 화면이 사라질 때 사용할 애니메이터 설정
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        AlertAnimatedTransitioning(.dismiss)
    }
}
