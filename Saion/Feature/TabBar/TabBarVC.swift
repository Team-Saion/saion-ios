//
//  TabBarVC.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import Combine
import UIKit

import CasePaths

import Navigation

final class TabBarVC: BaseTabBarVC<TabBar> {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: TabBarVM
    
    // MARK: Life Cycle
    
    init(
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        vm: TabBarVM
    ) {
        self.cancellables = cancellables
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 최초 화면 구성에 필요한 데이터 조회 요청
        vm.send(.viewDidLoad)
        
        // 사용자가 선택한 탭을 뷰모델에 전달해 접근 가능 여부 확인
        defaultTabBar.selectedIndexPublisher
            .sink { [weak vm] in vm?.send(.indexChanged($0)) }
            .store(in: &cancellables)
        
        // 접근 검증이 완료된 탭으로 실제 화면 전환
        vm.effect.compactMap { $0[case: \.selectTabIndex] }
            .sink { [weak self] in self?.selectedIndex = $0 }
            .store(in: &cancellables)
        
        // 현재 탭 인덱스로 탭바 UI 갱신
        publisher(for: \.selectedIndex)
            .sink { [weak self] in self?.defaultTabBar.updateUI($0) }
            .store(in: &cancellables)
    }
}
