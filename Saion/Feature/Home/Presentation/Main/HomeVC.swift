//
//  HomeVC.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

import UIKit

import SnapKit

import DesignSystem

final class HomeVC: UIViewController {
    
    // MARK: Properties
    
    
    // MARK: Components
    
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
    
    private let navigationBar = HomeNavigationBar()
    
    private let scrollView = {
        let view = ResponsiveScrollView()
        view.contentInset = .init(bottom: TabBar.height)
        view.scrollIndicatorInsets = .init(bottom: TabBar.height)
        return view
    }()
    
    private let contentVStack = UIStackView(.vertical, inset: .init(horizontal: 20))
    
    private let headerView = HomeHeaderView()
    
    private let dashboardView = HomeDashboardView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundLayer.frame = view.bounds
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.layer.addSublayer(backgroundLayer)
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(headerView)
        contentVStack.addArrangedSubview(UISpacer(12))
        contentVStack.addArrangedSubview(dashboardView)
        
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(scrollView.snp.top)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { HomeVC() }
