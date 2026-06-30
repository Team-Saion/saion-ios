//
//  BottomSheetPresentationController.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/23/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

final class BottomSheetPresentationController: UIPresentationController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    /// 디밍뷰 탭 제스처
    private let tapGesture = UITapGestureRecognizer()
    /// 시트 드래그 제스처
    private let panGesture = UIPanGestureRecognizer()
    
    /// 디밍뷰
    private lazy var dimmingView = {
        let view = UIView()
        view.backgroundColor = .overlayDimmer
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    // MARK: Life Cycle
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        setupDefaults()
        setupLayout()
        setupBindings()
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
        
        presentedView?.addGestureRecognizer(panGesture)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        guard let containerView, let presentedView else { return }
        
        containerView.addSubview(dimmingView)
        if presentedView.superview == nil { containerView.addSubview(presentedView) }
        
        presentedView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(containerView.safeAreaLayoutGuide).inset(12)
            $0.bottom.equalTo(containerView.safeAreaLayoutGuide)
        }
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 배경 탭하면 화면닫기
        tapGesture.tapPublisher
            .sink { [weak self] _ in self?.handleDimmingViewTap() }
            .store(in: &cancellables)
        
        // 시트를 아래로 끌어내리면 dismiss
        panGesture.panPublisher
            .sink { [weak self] in self?.handlePanGesture($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Private Helpers
    
    private func animatePresent() {
        guard let presentedView else { return }
        
        // 애니메이션 전 상태 세팅
        containerView?.layoutIfNeeded()
        presentedView.transform = .init(translationX: 0, y: presentedView.bounds.height)
        dimmingView.alpha = 0
        
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.presentedView?.transform = .identity
            self?.dimmingView.alpha = 1
        }
    }
    
    private func animateDismiss() {
        guard let presentedView else { return }
        
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            guard let self else { return }
            presentedView.transform = .init(translationX: 0, y: presentedView.bounds.height)
            dimmingView.alpha = 0
        }
    }
    
    // MARK: Reactive Interface
    
    private func handleDimmingViewTap() {
        if presentedViewController.isModalInPresentation {
            // 사용자가 화면을 닫으려고 시도했다는 사실을 뷰 컨트롤러에 통지
            delegate?.presentationControllerDidAttemptToDismiss?(self)
        } else {
            presentedViewController.dismiss(animated: true)
        }
    }
    
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let presentedView else { return }
        
        let translation = gesture.translation(in: presentedView)
        let velocity = gesture.velocity(in: presentedView)
        let visibleSheetHeight = presentedView.bounds.height
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                if presentedViewController.isModalInPresentation {
                    // isModalInPresentation일 때: 거의 움직이지 않도록 매우 강한 저항감 적용
                    // 당긴 거리의 1/15 정도만 움직이게 해서 안 닫힌다는 걸 즉각적으로 인지하게 함
                    let pullDownResistance: CGFloat = 15.0
                    let resistedY = translation.y / pullDownResistance
                    presentedView.transform = .init(translationX: 0, y: resistedY)
                    dimmingView.alpha = 1
                } else {
                    // 기본 상태: 1:1로 따라가기
                    presentedView.transform = .init(translationX: 0, y: translation.y)
                    
                    // 드래그 비율에 따라 디밍뷰 투명도 조절
                    let progress = min(translation.y / visibleSheetHeight, 1)
                    dimmingView.alpha = 1 - progress
                }
            } else {
                // 위로 당길 때: 리퀴드 글래스 느낌 (세로 늘어남 + 가로 줄어듦 + 미세하게 위로 끌려감)
                let maxStretch: CGFloat = 0.04 // 최대 4%까지만 늘어나도록 제한
                let stretchResistance: CGFloat = 6.0 // 늘어나는 저항 (더 뻑뻑하게)
                let pullResistance: CGFloat = 50.0 // 위로 끌려가는 저항 (훨씬 덜 끌려가게)
                
                let stretchProgress = min(
                    abs(translation.y) / (visibleSheetHeight * stretchResistance),
                    1.0
                )
                
                // 세로 스케일 (최대 5% 늘어남)
                let scaleY = 1.0 + maxStretch * sin(stretchProgress * .pi / 2)
                
                // 가로 스케일 (부피 유지 느낌: 세로가 늘어난 만큼 가로 축소)
                let scaleX = 1.0 / scaleY
                
                // 하단 고정을 위한 스케일 보정값 계산
                let scaleOffset = -(scaleY - 1.0) * visibleSheetHeight / 2.0
                
                // 미세하게 위로 끌려 올라가는 느낌 추가 (음수값)
                let upwardTranslation = translation.y / pullResistance
                
                presentedView.transform = CGAffineTransform(
                    translationX: 0,
                    y: scaleOffset + upwardTranslation
                ).scaledBy(x: scaleX, y: scaleY)
                dimmingView.alpha = 1
            }
            
        case .ended, .cancelled:
            let offsetY = translation.y
            let dismissThreshold = visibleSheetHeight * 0.4
            // 애플 시스템과 유사하게 살짝만 튕겨도 닫히도록 velocity 임계값을 낮춤
            let shouldDismiss = offsetY > dismissThreshold || velocity.y > 500
            
            if shouldDismiss {
                if presentedViewController.isModalInPresentation {
                    // 사용자가 화면을 닫으려고 시도했다는 사실을 뷰 컨트롤러에 통지
                    delegate?.presentationControllerDidAttemptToDismiss?(self)
                    // 원위치 복귀 (애플 시스템 느낌의 스프링 애니메이션)
                    UIView.animate(
                        withDuration: 0.4,
                        delay: 0,
                        usingSpringWithDamping: 0.8,
                        initialSpringVelocity: 0,
                        options: [.curveEaseOut, .allowUserInteraction]
                    ) { [weak self] in
                        self?.presentedView?.transform = .identity
                        self?.dimmingView.alpha = 1
                    }
                    
                } else {
                    presentedViewController.dismiss(animated: true)
                }
                
            } else {
                // 원위치 복귀 (애플 시스템 느낌의 스프링 애니메이션)
                UIView.animate(
                    withDuration: 0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: [.curveEaseOut, .allowUserInteraction]
                ) { [weak self] in
                    self?.presentedView?.transform = .identity
                    self?.dimmingView.alpha = 1
                }
            }
            
        default:
            break
        }
    }
}
