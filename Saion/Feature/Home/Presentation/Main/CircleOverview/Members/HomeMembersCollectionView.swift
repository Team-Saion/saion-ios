//
//  HomeMembersCollectionView.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import Combine
import UIKit

import DesignSystem

final class HomeMembersCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias Item = HomeMembersCollectionViewItem
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: max(1, contentSize.height)
        )
    }
    
    // MARK: Registrations
    
    /// 멤버 아이템을 멤버 셀로 구성하는 데이터 소스 레지스트레이션
    private let memberCellRegistration =
    CellRegistration<MemberCell, MemberCellItem> { cell, _, item in
        cell.configure(with: item)
    }
    
    /// 초대 아이템을 초대 셀로 구성하는 데이터 소스 레지스트레이션
    private let inviteCellRegistration =
    CellRegistration<InviteMemberCell, Void> { _, _, _ in }
    
    // MARK: DataSource
    
    /// 아이템 종류에 맞는 레지스트레이션으로 셀을 제공하는 데이터 소스
    private(set) lazy var diffableDataSource =
    UICollectionViewDiffableDataSource<Section, Item>(collectionView: self) {
        [weak self] collectionView, indexPath, collectionViewItem in
        guard let self else { return .init() }
        
        return switch collectionViewItem {
        case .member(let item):
            dequeueConfiguredReusableCell(
                using: memberCellRegistration,
                for: indexPath,
                item: item
            )
            
        case .invite:
            dequeueConfiguredReusableCell(
                using: inviteCellRegistration,
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
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    }
    
    // MARK: Collection Layout
    
    private func setupCollectionLayout() {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .estimated(64),
            heightDimension: .estimated(93)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .estimated(64),
                heightDimension: .estimated(93)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(horizontal: 20)
        section.interGroupSpacing = 16
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        collectionViewLayout = UICollectionViewCompositionalLayout(
            section: section,
            configuration: configuration
        )
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 콘텐츠 높이가 바뀐 때 intrinsicContentSize를 갱신해
        // 멤버 셀의 높이를 상위 레이아웃에 반영
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
}

// MARK: - Presentation Model

enum HomeMembersCollectionViewItem: Hashable {
    case member(MemberCellItem)
    case invite
}
