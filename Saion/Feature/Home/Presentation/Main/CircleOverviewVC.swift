//
//  CircleOverviewVC.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

import UIKit

import SnapKit

import DesignSystem

final class CircleOverviewVC: UIViewController {
    
    // MARK: Components
    
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
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        
        contentVStack.addArrangedSubview(headerView)
        contentVStack.addArrangedSubview(UISpacer(12))
        contentVStack.addArrangedSubview(dashboardView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentVStack.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
    }
}

// MARK: - Preview

#Preview { CircleOverviewVC() }
