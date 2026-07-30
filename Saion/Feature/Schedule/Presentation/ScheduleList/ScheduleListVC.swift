//
//  ScheduleListVC.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class ScheduleListVC: UIViewController {
    
    // MARK: Properties
    
    /// 화면 생명주기 동안 유지할 Combine 구독
    private var cancellables = Set<AnyCancellable>()
    /// 일정 목록 상태와 사용자 액션을 처리하는 뷰모델
    private let vm = ScheduleDI.shared.makeScheduleListVM()
    
    // MARK: Components
    
    /// 일정 목록과 일정 추가 진입점을 표시하는 컬렉션 뷰
    let collectionView = SchedulesCollectionView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .backgroundMuted
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 화면 등장 시 일정 변경 순번이 달라졌을 때만 목록 재조회
        viewDidAppearPublisher
            .map { ChangeTracker.shared.scheduleRevision }
            .removeDuplicates()
            .sink { [weak vm] _ in vm?.send(.reloadRequested) }
            .store(in: &cancellables)
        
        // 셀 노출 인덱스를 VM에 전달해 다음 페이지 선조회 여부 판단
        collectionView.willDisplayCellPublisher.map { $0.indexPath.item }
            .sink { [weak self] in self?.vm.send(.cellWillDisplay(index: $0)) }
            .store(in: &cancellables)
        
        // 일정 추가 이벤트 전달
        collectionView.addScheduleTapPublisher
            .sink { [weak self] in self?.vm.send(.createScheduleTapped) }
            .store(in: &cancellables)

        // 일정 선택 이벤트 전달
        collectionView.scheduleTapPublisher
            .sink { [weak self] in self?.vm.send(.scheduleTapped(scheduleID: $0)) }
            .store(in: &cancellables)
        
        // 일정 아이템으로 컬렉션뷰 스냅샷 갱신
        vm.$state
            .map(\.scheduleCellItems)
            .removeDuplicates()
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
    
    // MARK: Reactive Interface
    
    /// 일정 추가 퍼블리셔
    var createSchedulePublisher: AnyPublisher<Void, Never> {
        vm.effect.compactMap { $0[case: \.createSchedule] }.eraseToAnyPublisher()
    }

    /// 일정 상세 화면 전환 퍼블리셔
    var scheduleDetailPublisher: AnyPublisher<String, Never> {
        vm.effect.compactMap { $0[case: \.showScheduleDetail] }.eraseToAnyPublisher()
    }
}
