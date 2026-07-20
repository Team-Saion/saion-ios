//
//  MembersCollectionView.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import UIKit

import DesignSystem

final class MembersCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias Item = MemberCellItem
    
    // MARK: Registrations
    
    /// 멤버 아이템을 멤버 셀로 구성하는 데이터 소스 레지스트레이션
    private let memberCellRegistration =
    CellRegistration<MemberRowCell, Item> { cell, _, item in
        cell.configure(with: item)
    }
    
    // MARK: DataSource
    
    /// 아이템 종류에 맞는 레지스트레이션으로 셀을 제공하는 데이터 소스
    private(set) lazy var diffableDataSource =
    UICollectionViewDiffableDataSource<Section, Item>(collectionView: self) {
        [weak self] collectionView, indexPath, item in
        guard let self else { return .init() }
        
        return dequeueConfiguredReusableCell(
            using: memberCellRegistration,
            for: indexPath,
            item: item
        )
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
    
    private func setupDefaults() { backgroundColor = .clear }
    
    // MARK: Collection Layout
    
    private func setupCollectionLayout() {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(40)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(edges: 20)
        section.interGroupSpacing = 24
        
        collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: Configure
    
    func setSnapshot(items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}
