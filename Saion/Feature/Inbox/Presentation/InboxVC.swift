//
//  InboxVC.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class InboxVC: BackButtonVC {

    // MARK: Properties

    var cancellables = Set<AnyCancellable>()
    private let vm = InboxDI.shared.makeInboxVM()

    // MARK: Components

    /// 알림 목록을 표시하는 컬렉션 뷰
    let collectionView = InboxCollectionView()

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
        defaultNavBar.titleLabel.text = "알림"
    }

    // MARK: Layout

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }

    // MARK: Bindings

    private func setupBindings() {
        // 바인딩 구성이 끝난 뒤 최초 알림 목록 조회를 요청
        vm.send(.viewDidLoad)

        // 셀 노출 인덱스를 VM에 전달해 다음 페이지 선조회 여부 판단
        collectionView.willDisplayCellPublisher.map { $0.indexPath.item }
            .sink { [weak self] in self?.vm.send(.cellWillDisplay(index: $0)) }
            .store(in: &cancellables)

        // 알림 아이템으로 컬렉션뷰 스냅샷 갱신
        vm.$state
            .map(\.inboxItems)
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
}
