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
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 현재 탭 인덱스로 탭바 UI 갱신
        publisher(for: \.selectedIndex)
            .sink { [weak self] in self?.defaultTabBar.updateUI($0) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { TabBarVC() }
