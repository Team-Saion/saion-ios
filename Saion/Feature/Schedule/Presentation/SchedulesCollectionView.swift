//
//  SchedulesCollectionView.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa

import DesignSystem

final class SchedulesCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias Item = SchedulesCollectionViewItem
    
    // MARK: Registrations
    
    /// 일정 아이템을 일정 셀로 구성하는 데이터 소스 레지스트레이션
    private let scheduleCellRegistration =
    CellRegistration<ScheduleCell, ScheduleCellItem> { cell, _, item in
        cell.configure(with: item)
    }
    
    /// 일정 추가 아이템을 추가 셀로 구성하는 데이터 소스 레지스트레이션
    private let addScheduleCellRegistration =
    CellRegistration<AddScheduleCell, Void> { _, _, _ in }
    
    // MARK: DataSource
    
    /// 아이템 종류에 맞는 레지스트레이션으로 셀을 제공하는 데이터 소스
    private(set) lazy var diffableDataSource =
    UICollectionViewDiffableDataSource<Section, Item>(collectionView: self) {
        [weak self] _, indexPath, collectionViewItem in
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        backgroundColor = .clear
        contentInset = .init(bottom: TabBar.height)
        verticalScrollIndicatorInsets = .init(bottom: TabBar.height)
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
        section.contentInsets = .init(edges: 20)
        section.interGroupSpacing = 8
        
        collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: Configure
    
    func setSnapshot(items: [ScheduleCellItem]) {
        let items = items.map(Item.schedule) + [.add]
        
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
enum SchedulesCollectionViewItem: Hashable {
    case schedule(ScheduleCellItem)
    case add
}
