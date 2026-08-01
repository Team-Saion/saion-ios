//
//  MemberListVC.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class MemberListVC: BackButtonVC {
    
    // MARK: Properties
    
    /// 화면 생명주기 동안 유지할 Combine 구독
    var cancellables = Set<AnyCancellable>()
    
    /// 구성원 목록 상태와 사용자 액션을 처리하는 뷰모델
    private let vm: MemberListVM
    
    // MARK: Components
    
    /// 현재 서클의 구성원을 표시하는 컬렉션 뷰
    private let collectionView = MembersCollectionView()
    
    // MARK: Life Cycle
    
    init(vm: MemberListVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { view.backgroundColor = .backgroundMuted }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 화면 진입 후 구성원 목록 및 내 프로필 조회 요청
        vm.send(.viewDidLoad)
        
        // 구성원 셀 아이템 목록을 컬렉션뷰에 반영
        vm.$state.map(\.memberItems).removeDuplicates()
            .sink { [weak self] in self?.collectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        // 로딩 상태에 따라 로딩 인디케이터 노출 여부 갱신
        vm.$state.map(\.isLoading).removeDuplicates()
            .sink { [weak self] in self?.setLoadingIndicatorVisible($0) }
            .store(in: &cancellables)
        
        // 상태 전이 중 발생한 에러를 알림으로 표시
        vm.effect.compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
    }
}
