//
//  BaseTabBarVC.swift
//  Navigation
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 앱 탭바(자체 커스텀 탭바)를 사용하는 탭바 컨트롤러
/// - Important: 반드시 `setViewControllers(_:animated:)`를 사용해서 뷰컨트롤러를 구성해야 합니다!
open class BaseTabBarVC<TabBar: BaseTabBar>:
    UITabBarController,
    TabBarContaining
{
    
    // MARK: Properties
    
    /// 시스템 TabBar의 제약을 피하고 자유로운 애니메이션 구현을 위해 커스텀 객체 사용
    public let defaultTabBar = TabBar()
    
    // MARK: Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 시스템 탭바 항상 숨기기
        tabBar.isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(defaultTabBar)
        
        defaultTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 하단 Safe Area 영역까지 포함하여 배경색이 채워지도록 설정
        NSLayoutConstraint.activate([
            defaultTabBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -type(of: defaultTabBar).height
            ),
            defaultTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Public Methods
    
    open override func setViewControllers(
        _ viewControllers: [UIViewController]?,
        animated: Bool
    ) {
        super.setViewControllers(viewControllers, animated: animated)
        defaultTabBar.setItems(viewControllers?.map(\.tabBarItem))
    }
}
