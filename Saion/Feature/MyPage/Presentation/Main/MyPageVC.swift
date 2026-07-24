//
//  MyPageVC.swift
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

final class MyPageVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyPageDI.shared.makeMyPageVM()
    
    // MARK: Components
    
    /// 화면 콘텐츠 스크롤 뷰
    private let scrollView = ResponsiveScrollView()
    /// 프로필과 설정 메뉴를 배치하는 수직 스택
    private let contentVStack = UIStackView(.vertical, alignment: .center)
    
    /// 알림 설정 메뉴 컨테이너
    private let rowVStack1 = {
        let view = UIStackView(.vertical)
        view.inset = .init(vertical: 12)
        view.layer.cornerRadius = Radius.containerLarge
        view.clipsToBounds = true
        view.backgroundColor = .backgroundDefault
        return view
    }()
    
    /// 계정 관리 메뉴 컨테이너
    private let rowVStack2 = {
        let view = UIStackView(.vertical)
        view.inset = .init(vertical: 12)
        view.layer.cornerRadius = Radius.containerLarge
        view.clipsToBounds = true
        view.backgroundColor = .backgroundDefault
        return view
    }()
    
    /// 사용자 프로필 이미지
    private let profileImageView = ProfileImageView(size: .large)
    
    /// 프로필 편집 버튼
    private let editProfileButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        config.image = .myGear
        return UIButton(configuration: config)
    }()
    
    /// 사용자 이름 레이블
    private let nameLabel = {
        let textStyle = TextStyle(
            typography: .title1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = AttributedLabel()
        label.textAttributes = textStyle.toDictionary()
        return label
    }()
    
    /// 알림 설정 메뉴
    private let notificationRow = RowButton(title: "알림 설정")
    /// 로그아웃 메뉴
    private let logoutRow = RowButton(title: "로그아웃")
    /// 회원 탈퇴 메뉴
    private let deleteAccountRow = RowButton(title: "회원 탈퇴")
    
    // MARK: Life Cycle
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        
        contentVStack.addArrangedSubview(UISpacer(52))
        contentVStack.addArrangedSubview(profileImageView)
        contentVStack.addArrangedSubview(UISpacer(8))
        contentVStack.addArrangedSubview(nameLabel)
        contentVStack.addArrangedSubview(UISpacer(32))
        contentVStack.addArrangedSubview(rowVStack1)
        contentVStack.addArrangedSubview(UISpacer(12))
        contentVStack.addArrangedSubview(rowVStack2)
        
        contentVStack.addSubview(editProfileButton)
        
        rowVStack1.addArrangedSubview(notificationRow)
        rowVStack2.addArrangedSubview(logoutRow)
        rowVStack2.addArrangedSubview(deleteAccountRow)
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(TabBar.height)
        }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        editProfileButton.snp.makeConstraints { $0.bottom.trailing.equalTo(profileImageView) }
        rowVStack1.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(20) }
        rowVStack2.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(20) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 로그아웃 확인 얼럿에서 승인한 경우 VM에 로그아웃 이벤트 전달
        logoutRow.tapPublisher
            .compactMap { [weak self] in self?.presentLogoutConfirmAlert() }
            .switchToLatest()
            .sink { [weak self] in self?.vm.send(.logoutTapped) }
            .store(in: &cancellables)
        
        // 프로필 이미지 상태 바인딩
        vm.$state.compactMap(\.profileViewState).removeDuplicates()
            .sink { [weak self] in self?.profileImageView.configure(with: $0) }
            .store(in: &cancellables)
        
        // 사용자 이름 바인딩
        vm.$state.compactMap(\.name).removeDuplicates()
            .sink { [weak self] in self?.nameLabel.text = $0 }
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
    
    /// 로그아웃 확인 얼럿 노출
    private func presentLogoutConfirmAlert() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let alert = ConfirmAlertVC(acceptVariant: .primary)
            alert.titleLabel.text = "로그아웃 하시겠어요?"
            alert.acceptButton.title = "로그아웃"
            
            alert.cancelButton.tapPublisher
                .sink { [weak alert] in alert?.dismiss(animated: true) }
                .store(in: &alert.cancellables)
            
            alert.acceptButton.tapPublisher
                .sink { [weak alert] in alert?.dismiss(animated: true) { promise(.success(())) } }
                .store(in: &alert.cancellables)
            
            self?.present(alert, animated: true)
        } }
        .eraseToAnyPublisher()
    }
    
    /// 회원 탈퇴 탭 퍼블리셔
    var deleteAccountTapPublisher: AnyPublisher<Void, Never> { deleteAccountRow.tapPublisher }
    /// 푸시알림 설정 탭 퍼블리셔
    var notificationTapPublisher: AnyPublisher<Void, Never> { notificationRow.tapPublisher }
}

// MARK: - RowButton

private final class RowButton: UIButton {
    
    // MARK: Properties
    
    let title: String
    
    // MARK: Life Cycle
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        let titleStyle = TextStyle(
            typography: .title3,
            decoration: .init(foregroundColor: .labelDefault)
        )
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(leading: 24, trailing: 16)
        config.attributedTitle = titleStyle.toAttrStr(title)
        config.image = .chevronRightMedium.withTintColor(.grey400)
        config.imagePlacement = .trailing
        
        contentHorizontalAlignment = .fill
        configuration = config
    }
    
    // MARK: Layout
    
    private func setupLayout() { self.snp.makeConstraints { $0.height.equalTo(44) } }
}

// MARK: - Preview

#Preview { MyPageVC() }
