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
    
    /// 마지막으로 적용한 시트 높이
    private var currentSheetHeight: CGFloat = 0
    
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
    
    /// 컨텐츠 뷰의 그림자
    private lazy var shadowView = {
        let view = UIStackView()
        view.layer.shadowColor = Shadow.container.shadowColor.cgColor
        view.layer.shadowOpacity = Shadow.container.shadowOpacity
        view.layer.shadowOffset = Shadow.container.shadowOffset
        view.layer.shadowRadius = Shadow.container.shadowRadius
        view.addGestureRecognizer(panGesture)
        return view
    }()
    
    /// 실제 컨텐츠가 들어가는 뷰
    private let contentView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Radius.containerXlarge
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: Life Cycle
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        setupLayout()
        setupBindings()
        animatePresent()
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animateDismiss()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        guard let containerView, let presentedView else { return }
        
        containerView.addSubview(dimmingView)
        containerView.addSubview(shadowView)
        
        shadowView.addArrangedSubview(contentView)
        if presentedView.superview == nil { contentView.addArrangedSubview(presentedView) }
        
        // 제약 적용 전에 초기 높이 계산
        let initialHeight = calculateFittingHeight()
        currentSheetHeight = initialHeight
        
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        shadowView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(containerView.safeAreaLayoutGuide).inset(12)
            $0.bottom.equalTo(containerView.safeAreaLayoutGuide)
            $0.height.equalTo(initialHeight)
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
    
    // MARK: Overrides
    
    /// 레이아웃이 반영된 시점마다 시트 높이를 재계산함
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        /// 실제 시트에 적용할 최종 높이
        let finalHeight = calculateFittingHeight()
        
        // 잘못된 계산으로 0 이하가 나온 경우는 무시함
        guard finalHeight > 0 else { return }
        
        // 이전 높이와 거의 차이가 없으면 다시 적용하지 않음 (무한 루프 방지)
        guard abs(currentSheetHeight - finalHeight) > 0.5 else { return }
        
        // 이번에 계산된 높이를 현재 높이로 저장해둠
        currentSheetHeight = finalHeight
        
        // 높이 제약 갱신으로 시트 높이 적용
        shadowView.snp.updateConstraints { $0.height.equalTo(finalHeight) }
        
        // 시트 높이 변경을 자연스럽게 반영하기 위해 animate 사용
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.containerView?.layoutIfNeeded()
        }
    }
    
    // MARK: Private Helpers
    
    /// presentedView의 intrinsicContentSize 기준으로 fitting height를 계산함
    private func calculateFittingHeight() -> CGFloat {
        guard let containerView, let presentedView else { return 0 }
        
        let targetSize = CGSize(
            width: containerView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        
        let contentHeight = presentedView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        return contentHeight
    }
    
    private func animatePresent() {
        // 애니메이션 전 상태 세팅
        containerView?.layoutIfNeeded()
        shadowView.transform = .init(translationX: 0, y: currentSheetHeight)
        dimmingView.alpha = 0
        
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.shadowView.transform = .identity
            self?.dimmingView.alpha = 1
        }
    }
    
    private func animateDismiss() {
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            guard let self else { return }
            shadowView.transform = .init(translationX: 0, y: currentSheetHeight)
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
        let translation = gesture.translation(in: shadowView)
        let velocity = gesture.velocity(in: shadowView)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                if presentedViewController.isModalInPresentation {
                    // isModalInPresentation일 때: 거의 움직이지 않도록 매우 강한 저항감 적용
                    // 당긴 거리의 1/15 정도만 움직이게 해서 안 닫힌다는 걸 즉각적으로 인지하게 함
                    let pullDownResistance: CGFloat = 15.0
                    let resistedY = translation.y / pullDownResistance
                    shadowView.transform = .init(translationX: 0, y: resistedY)
                    dimmingView.alpha = 1
                } else {
                    // 기본 상태: 1:1로 따라가기
                    shadowView.transform = .init(translationX: 0, y: translation.y)
                    
                    // 드래그 비율에 따라 디밍뷰 투명도 조절
                    let progress = min(translation.y / currentSheetHeight, 1)
                    dimmingView.alpha = 1 - progress
                }
            } else {
                // 위로 당길 때: 리퀴드 글래스 느낌 (세로 늘어남 + 가로 줄어듦 + 미세하게 위로 끌려감)
                let maxStretch: CGFloat = 0.04 // 최대 4%까지만 늘어나도록 제한
                let stretchResistance: CGFloat = 6.0 // 늘어나는 저항 (더 뻑뻑하게)
                let pullResistance: CGFloat = 50.0 // 위로 끌려가는 저항 (훨씬 덜 끌려가게)
                
                let stretchProgress = min(
                    abs(translation.y) / (currentSheetHeight * stretchResistance),
                    1.0
                )
                
                // 세로 스케일 (최대 5% 늘어남)
                let scaleY = 1.0 + maxStretch * sin(stretchProgress * .pi / 2)
                
                // 가로 스케일 (부피 유지 느낌: 세로가 늘어난 만큼 가로 축소)
                let scaleX = 1.0 / scaleY
                
                // 하단 고정을 위한 스케일 보정값 계산
                let scaleOffset = -(scaleY - 1.0) * currentSheetHeight / 2.0
                
                // 미세하게 위로 끌려 올라가는 느낌 추가 (음수값)
                let upwardTranslation = translation.y / pullResistance
                
                shadowView.transform = CGAffineTransform(
                    translationX: 0,
                    y: scaleOffset + upwardTranslation
                ).scaledBy(x: scaleX, y: scaleY)
                dimmingView.alpha = 1
            }
            
        case .ended, .cancelled:
            let offsetY = translation.y
            let dismissThreshold = currentSheetHeight * 0.4
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
                        self?.shadowView.transform = .identity
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
                    self?.shadowView.transform = .identity
                    self?.dimmingView.alpha = 1
                }
                
            }
            
        default:
            break
        }
    }
}

