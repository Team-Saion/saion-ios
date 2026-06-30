//
//  AlertPresentationController.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/30/26.
//

import UIKit

import SnapKit

final class AlertPresentationController: UIPresentationController {
    
    // MARK: Properties
    
    /// 키보드가 얼럿을 가리지 않는 레이아웃 가이드
    private let contentLayoutGuide = UILayoutGuide()
    
    // MARK: Components
    
    /// 디밍뷰
    private let dimmingView = {
        let control = UIView()
        control.backgroundColor = .overlayDimmer
        return control
    }()
    
    // MARK: Life Cycle
    
    /// 전환 애니메이션을 시작하려는 직전의 시점
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        setupDefaults()
        setupLayout()
        animatePresent()
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animateDismiss()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        presentedView?.backgroundColor = .backgroundDefault
        presentedView?.layer.cornerRadius = Radius.containerXlarge
        
        presentedView?.layer.cornerRadius = Radius.containerXxlarge
        presentedView?.layer.shadowColor = Shadow.component.shadowColor
        presentedView?.layer.shadowOpacity = Shadow.component.shadowOpacity
        presentedView?.layer.shadowOffset = Shadow.component.shadowOffset
        presentedView?.layer.shadowRadius = Shadow.component.shadowRadius
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        guard let containerView, let presentedView else { return }
        
        containerView.addLayoutGuide(contentLayoutGuide)
        containerView.addSubview(dimmingView)
        if presentedView.superview == nil { containerView.addSubview(presentedView) }
        
        contentLayoutGuide.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(containerView.safeAreaLayoutGuide)
            $0.bottom.equalTo(containerView.keyboardLayoutGuide.snp.top)
        }
        presentedView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentLayoutGuide).inset(32)
            $0.centerY.equalTo(contentLayoutGuide)
        }
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Private Helpers
    
    private func animatePresent() {
        dimmingView.alpha = 0
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.dimmingView.alpha = 1
        }
    }
    
    private func animateDismiss() {
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.dimmingView.alpha = 0
        }
    }
}
