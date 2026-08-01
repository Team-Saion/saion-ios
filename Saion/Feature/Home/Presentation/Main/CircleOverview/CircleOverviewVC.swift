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
    
    /// 화면 생명주기 동안 유지할 Combine 구독
    var cancellables = Set<AnyCancellable>()
    
    /// 서클 홈 상태와 사용자 액션을 처리하는 뷰모델
    private let vm: CircleOverviewVM
    
    // MARK: Components
    
    /// 홈 상단 내비게이션 바
    private let navigationBar = HomeNavigationBar()

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
    
    init(vm: CircleOverviewVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = HomeBackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(navigationBar)
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
        
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(scrollView.snp.top)
        }
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        addScheduleButtonContainer.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20 + TabBar.height)
        }
        addScheduleButton.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 최초 로드와 화면 등장 시 서클 변경 순번이 달라졌을 때만 재조회
        viewDidAppearPublisher.prepend(())
            .map { ChangeTracker.shared.circleRevision }
            .removeDuplicates()
            .sink { [weak vm] _ in vm?.send(.reloadRequested) }
            .store(in: &cancellables)
        
        // 홈 내 초대 진입점의 탭 이벤트를 하나의 액션으로 전달
        Publishers.Merge(
            membersView.collectionView.inviteMemberTapPublisher,
            dashboardView.inviteTapPublisher
        )
        .sink { [weak self] in self?.vm.send(.inviteTapped) }
        .store(in: &cancellables)
        
        // 대표 일정 공유 확인 후 가족 알림 전송 요청
        dashboardView.shareTapPublisher
            .compactMap { [weak self] in self?.presentShareConfirmAlert() }
            .switchToLatest()
            .sink { [weak self] in self?.vm.send(.shareTapped) }
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
        
        // 발급된 구성원 초대 링크를 외부 앱으로 열기
        vm.effect.compactMap { $0[case: \.openInviteURL] }
            .sink { UIApplication.shared.open($0) }
            .store(in: &cancellables)
        
        // 전체 일정 보기 탭하면 일정 탭으로 이동
        schedulesView.showAllButton.tapPublisher
            .sink { [weak self] in self?.tabBarController?.selectedIndex = 1 }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 알림 버튼 탭 퍼블리셔
    var notificationTapPublisher: AnyPublisher<Void, Never> {
        navigationBar.notificationButton.tapPublisher.eraseToAnyPublisher()
    }

    /// 일정 공유 확인 얼럿 노출
    private func presentShareConfirmAlert() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let alert = ConfirmAlertVC(acceptVariant: .primary)
            alert.titleLabel.text = "모두에게 이 일정을 전할까요?"
            alert.acceptButton.title = "전하기"
            
            alert.cancelButton.tapPublisher
                .sink { [weak alert] in alert?.dismiss(animated: true) }
                .store(in: &alert.cancellables)
            
            alert.acceptButton.tapPublisher
                .sink { [weak alert] in alert?.dismiss(animated: true) {
                    promise(.success(())) }
                }
                .store(in: &alert.cancellables)
            
            self?.present(alert, animated: true)
        } }
        .eraseToAnyPublisher()
    }
    
    /// 일정 추가 퍼블리셔
    var createSchedulePublisher: AnyPublisher<Void, Never> {
        Publishers.Merge(
            schedulesView.collectionView.addScheduleTapPublisher,
            addScheduleButton.tapPublisher
        )
        .eraseToAnyPublisher()
    }
    
    /// 일정 상세 화면 전환 퍼블리셔
    var scheduleDetailPublisher: AnyPublisher<String, Never> {
        schedulesView.collectionView.scheduleTapPublisher
    }

    /// 전체 구성원 보기 탭 퍼블리셔
    var showAllMembersTapPublisher: AnyPublisher<Void, Never> {
        membersView.showAllButton.tapPublisher
    }
}

// MARK: - Preview

#Preview {
    CircleOverviewVC(
        vm: HomeDI.shared.makeCircleOverviewVM(circleID: "preview-circle-id")
    )
}
