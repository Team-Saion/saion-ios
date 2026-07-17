//
//  CircleOverviewVC.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem

final class CircleOverviewVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let vm = HomeDI.shared.makeCircleOverviewVM()
    
    // MARK: Components
    
    /// 홈 콘텐츠를 세로로 탐색하는 스크롤 뷰
    private let scrollView = {
        let view = ResponsiveScrollView()
        view.contentInset = .init(bottom: TabBar.height)
        view.scrollIndicatorInsets = .init(bottom: TabBar.height)
        return view
    }()
    
    /// 홈의 각 섹션을 세로로 배치하는 콘텐츠 스택
    private let contentVStack = UIStackView(.vertical)
    
    /// 서클 이름을 표시하는 헤더 뷰
    private let headerView = HomeHeaderView()
    
    /// 서클의 대표 일정과 요약 정보를 표시하는 대시보드 뷰
    private let dashboardView = HomeDashboardView()
    
    /// 일정 목록을 표시하는 뷰
    private let schedulesView = HomeSchedulesView()
    
    /// 구성원 목록과 초대 항목을 표시하는 뷰
    private let membersView = HomeMembersView()
    
    /// 일정 추가 버튼의 그림자를 표시하는 컨테이너
    private let addScheduleButtonContainer = {
        let view = UIView()
        view.layer.shadowColor = Shadow.component.shadowColor
        view.layer.shadowOpacity = Shadow.component.shadowOpacity
        view.layer.shadowOffset = Shadow.component.shadowOffset
        view.layer.shadowRadius = Shadow.component.shadowRadius
        return view
    }()
    
    /// 일정 추가 버튼
    private let addScheduleButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "일정 추가"
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(addScheduleButtonContainer)
        addScheduleButtonContainer.addSubview(addScheduleButton)
        scrollView.addSubview(contentVStack)
        
        contentVStack.addArrangedSubview(headerView)
        contentVStack.addArrangedSubview(UISpacer(12))
        contentVStack.addArrangedSubview(dashboardView)
        contentVStack.addArrangedSubview(UISpacer(32))
        contentVStack.addArrangedSubview(schedulesView)
        contentVStack.addArrangedSubview(UISpacer(32))
        contentVStack.addArrangedSubview(membersView)
        contentVStack.addArrangedSubview(UISpacer(64))
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        addScheduleButtonContainer.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20 + TabBar.height)
        }
        addScheduleButton.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        vm.send(.viewDidLoad)
        
        // 일정 추가 이벤트 전달
        Publishers.Merge(
            schedulesView.collectionView.addScheduleTapPublisher,
            addScheduleButton.tapPublisher
        )
        .sink { [weak self] in self?.vm.send(.createScheduleTapped) }
        .store(in: &cancellables)
        
        // 서클 이름을 헤더에 반영
        vm.$state.compactMap(\.circleTitle).removeDuplicates()
            .sink { [weak self] in self?.headerView.titleLabel.text = $0 }
            .store(in: &cancellables)
        
        // 대시보드 상태를 대시보드 뷰에 반영
        vm.$state.compactMap(\.dashboardViewState).removeDuplicates()
            .sink { [weak self] in self?.dashboardView.configure(with: $0) }
            .store(in: &cancellables)
        
        // 일정 아이템으로 일정 컬렉션뷰 스냅샷 갱신
        vm.$state.map(\.schedulesCollectionViewItems).removeDuplicates()
            .sink { [weak self] in self?.schedulesView.collectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        // 구성원 아이템으로 구성원 컬렉션뷰 스냅샷 갱신
        vm.$state.map(\.membersCollectionViewItems).removeDuplicates()
            .sink { [weak self] in self?.membersView.collectionView.setSnapshot(items: $0) }
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
    
    // MARK: Reactive Interface
    
    /// 화면 새로 고침
    func refresh() { vm.send(.refreshTriggered) }
    
    // 일정 추가 퍼블리셔
    var createSchedulePublisher: AnyPublisher<String, Never> {
        vm.effect.compactMap { $0[case: \.createSchedule] }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { CircleOverviewVC() }
