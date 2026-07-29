//
//  TabBarVC.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import Combine
import UIKit

import Navigation

final class TabBarVC: BaseTabBarVC<TabBar> {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 홈 뷰컨트롤러
    private let homeVC: UIViewController
    /// 일정 뷰컨트롤러
    private let scheduleVC: UIViewController
    /// 마이페이지 뷰컨트롤러
    private let myPageVC: UIViewController
    
    // MARK: Life Cycle
    
    init(
        homeVC: UIViewController,
        scheduleVC: UIViewController,
        myPageVC: UIViewController
    ) {
        self.homeVC = homeVC
        self.scheduleVC = scheduleVC
        self.myPageVC = myPageVC
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        setViewControllers([homeVC, scheduleVC, myPageVC], animated: false)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 현재 탭 인덱스로 탭바 UI 갱신
        publisher(for: \.selectedIndex)
            .sink { [weak self] in self?.defaultTabBar.updateUI($0) }
            .store(in: &cancellables)
    }
}
