//
//  HomeSchedulesCollectionView.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa

final class HomeSchedulesCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias Item = HomeSchedulesCollectionViewItem
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: max(1, contentSize.height)
        )
    }
    
    // MARK: Registrations
    
    /// 일정 아이템을 일정 셀로 구성하는 데이터 소스 레지스트레이션
    private let scheduleCellRegistration =
    CellRegistration<ScheduleCell, ScheduleCellItem> { cell, indexPath, item in
        cell.configure(with: item)
    }
    
    /// 일정 추가 아이템을 추가 셀로 구성하는 데이터 소스 레지스트레이션
    private let addScheduleCellRegistration =
    CellRegistration<AddScheduleCell, Void> { _, _, _ in }
    
    // MARK: DataSource
    
    /// 아이템 종류에 맞는 레지스트레이션으로 셀을 제공하는 데이터 소스
    private(set) lazy var diffableDataSource =
    UICollectionViewDiffableDataSource<Section, Item>(collectionView: self) {
        [weak self] collectionView, indexPath, collectionViewItem in
        guard let self else { return .init() }
        
        return switch collectionViewItem {
        case .schedule(let item):
            dequeueConfiguredReusableCell(
                using: scheduleCellRegistration,
                for: indexPath,
                item: item
            )
            
        case .add:
            dequeueConfiguredReusableCell(
                using: addScheduleCellRegistration,
                for: indexPath,
                item: ()
            )
        }
    }
    
    // MARK: Life Cycle
    
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        setupDefaults()
        setupCollectionLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        isScrollEnabled = false
        backgroundColor = .clear
    }
    
    // MARK: Collection Layout
    
    private func setupCollectionLayout() {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(64)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(64)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 콘텐츠 높이가 바뀔 때 intrinsicContentSize를 갱신해
        // 스크롤 없이 모든 일정이 노출되도록 상위 레이아웃에 알림
        publisher(for: \.contentSize).map(\.height).removeDuplicates()
            .sink { [weak self] _ in self?.invalidateIntrinsicContentSize() }
            .store(in: &cancellables)
    }
    
    // MARK: Configure
    
    func setSnapshot(items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: Reactive Interface
    
    /// 일정 셀 선택 시 일정 ID를 방출하는 퍼블리셔
    var scheduleTapPublisher: AnyPublisher<String, Never> {
        didSelectItemPublisher
            .compactMap { [weak self] indexPath in
                self?.diffableDataSource
                    .itemIdentifier(for: indexPath)?[case: \.schedule]?
                    .scheduleID
            }
            .eraseToAnyPublisher()
    }
    
    /// 일정 추가 셀 선택 퍼블리셔
    var addScheduleTapPublisher: AnyPublisher<Void, Never> {
        didSelectItemPublisher
            .filter { [weak self] indexPath in
                guard let self else { return false }
                return cellForItem(at: indexPath) is AddScheduleCell
            }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

// MARK: - Presentation Model

@CasePathable
enum HomeSchedulesCollectionViewItem: Hashable {
    case schedule(ScheduleCellItem)
    case add
}
