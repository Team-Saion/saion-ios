//
//  HomeVC.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

import Combine
import UIKit

import SnapKit

import DesignSystem

final class HomeVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = HomeDI.shared.makeHomeVM()
    
    /// 현재 표시 중인 콘텐츠 뷰컨트롤러
    private var currentContentVC: UIViewController?
    
    // MARK: Components
    
    /// 홈 배경 그라데이션 레이어
    private let backgroundLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.yellow50.cgColor,
            UIColor.backgroundMuted.cgColor
        ]
        layer.locations = [0.0, 0.5962]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    /// 홈 상단 내비게이션 바
    private let navigationBar = HomeNavigationBar()
    
    /// 자식 뷰컨트롤러가 표시되는 영역
    private let contentView = UIView()
    
    /// 서클 참여 전 콘텐츠 뷰컨트롤러
    private let entryVC = CircleEntryVC()
    
    /// 서클 참여 후 콘텐츠 뷰컨트롤러
    private let overviewVC = CircleOverviewVC()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundLayer.frame = view.bounds
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.layer.addSublayer(backgroundLayer)
        view.addSubview(navigationBar)
        view.addSubview(contentView)
        
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(contentView.snp.top)
        }
        contentView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        vm.send(.viewDidLoad)
        
        vm.$state
            .compactMap(\.content)
            .sink { [weak self] in self?.setContentVC($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 선택한 콘텐츠 뷰컨트롤러로 크로스 디졸브 전환
    private func setContentVC(_ content: HomeContent) {
        let nextVC = switch content {
        case .entry:       entryVC
        case .overview:    overviewVC
        }
        guard currentContentVC !== nextVC else { return }
        
        // 이전 VC는 애니메이션 전에 제거 예정 상태로 전환
        // nil인 최초 전환은 이 단계만 건너뜀
        let previousVC = currentContentVC
        previousVC?.willMove(toParent: nil)
        
        // addChild는 nextVC의 willMove(toParent:)를 자동 호출
        addChild(nextVC)
        
        // 자식 관계는 유지한 채 애니메이션 블록에서 뷰 계층만 교체
        UIView.transition(
            with: contentView,
            duration: 0.32,
            options: [
                .transitionCrossDissolve,
                .allowAnimatedContent,
                .curveEaseInOut
            ]
        ) { [self] in
            previousVC?.view.removeFromSuperview()
            contentView.addSubview(nextVC.view)
            nextVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
            
        } completion: { [weak self] _ in
            // 애니메이션 완료 후 이전 VC 제거와 새 VC 추가를 확정
            previousVC?.removeFromParent()
            nextVC.didMove(toParent: self)
        }
        
        // 전환 중 같은 콘텐츠가 다시 요청되지 않도록 즉시 현재값 갱신
        currentContentVC = nextVC
    }
    
}

// MARK: - View State

enum HomeContent {
    case entry
    case overview
}

// MARK: - Preview

#Preview { HomeVC() }
