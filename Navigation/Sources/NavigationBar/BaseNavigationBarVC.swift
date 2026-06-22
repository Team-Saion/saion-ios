//
//  BaseNavigationBarVC.swift
//  Navigation
//
//  Created by 신정욱 on 4/24/26.
//

import UIKit

/// 커스텀 네비게이션 바 뷰 컨트롤러
open class BaseNavigationBarVC<NavigationBar: BaseNavigationBar>: UIViewController {
    
    // MARK: Properties
    
    /// 네비게이션바와 탭바에 의해 가려지지 않는 실제 컨텐츠 배치 영역
    public let contentLayoutGuide = UILayoutGuide()
    
    // MARK: Components
    
    /// 상단 네비게이션 바
    public let defaultNavBar = NavigationBar()
    
    // MARK: Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(defaultNavBar)
        view.addLayoutGuide(contentLayoutGuide)
        
        defaultNavBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 상단 Safe Area 영역까지 포함하여 배경색이 채워지도록 설정
        NSLayoutConstraint.activate([
            defaultNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            defaultNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultNavBar.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: type(of: defaultNavBar).height
            ),
            
            contentLayoutGuide.topAnchor.constraint(equalTo: defaultNavBar.bottomAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentLayoutGuide.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}
