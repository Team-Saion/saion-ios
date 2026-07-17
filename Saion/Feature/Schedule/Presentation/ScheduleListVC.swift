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
    
    private var cancellables = Set<AnyCancellable>()
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
        // 바인딩 구성이 끝난 뒤 최초 일정 목록 조회를 요청
        vm.send(.viewDidLoad)
        
        // 셀 노출 인덱스를 VM에 전달해 다음 페이지 선조회 여부 판단
        collectionView.willDisplayCellPublisher.map { $0.indexPath.item }
            .sink { [weak self] in self?.vm.send(.cellWillDisplay(index: $0)) }
            .store(in: &cancellables)
        
        // 일정 추가 이벤트 전달
        collectionView.addScheduleTapPublisher
            .sink { [weak self] in self?.vm.send(.createScheduleTapped) }
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
    
    /// 화면 새로 고침
    func refresh() { vm.send(.refreshTriggered) }
    
    /// 일정 추가 퍼블리셔
    var createSchedulePublisher: AnyPublisher<String, Never> {
        vm.effect.compactMap { $0[case: \.createSchedule] }.eraseToAnyPublisher()
    }
}
