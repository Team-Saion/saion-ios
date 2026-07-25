//
//  JoinConfirmationVC.swift
//  Saion
//
//  Created by 신정욱 on 7/25/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class JoinConfirmationVC: BackButtonVC {

    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()
    private let vm: JoinConfirmationVM

    // MARK: Components

    /// 초대 안내 문구와 참여 버튼을 배치하는 메인 스택
    private let mainVStack = UIStackView(.vertical, inset: .init(horizontal: 20))

    /// 초대한 사용자와 서클 정보를 표시하는 안내 레이블
    private let promptLabel = {
        let style = TextStyle(
            typography: .heading1,
            decoration: .init(foregroundColor: .grey900),
            paragraph: .init(alignment: .center)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()

    /// 초대를 수락하고 서클 참여를 요청하는 버튼
    private let submitButton = {
        let appearance = SaionButton.Appearance(size: .xlarge, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "지금 참여하기"
        return button
    }()

    // MARK: Life Cycle

    init(vm: JoinConfirmationVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }

    // MARK: Defaults

    private func setupDefaults() { view.backgroundColor = .white }

    // MARK: Layout

    private func setupLayout() {
        view.addSubview(mainVStack)

        mainVStack.addArrangedSubview(UISpacer(188))
        mainVStack.addArrangedSubview(promptLabel)
        mainVStack.addArrangedSubview(UISpacer())
        mainVStack.addArrangedSubview(submitButton)

        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }

    // MARK: Bindings

    private func setupBindings() {
        // 화면 진입 후 초대장 상세 조회 요청
        vm.send(.viewDidLoad)

        // 참여 버튼 탭 이벤트를 VM에 전달
        submitButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.submitTapped) }
            .store(in: &cancellables)

        // 조회한 초대장 정보로 안내 문구 갱신
        vm.$state.compactMap(\.promptMessage).removeDuplicates()
            .sink { [weak self] in self?.promptLabel.text = $0 }
            .store(in: &cancellables)

        // 초대 수락 요청 상태에 따라 로딩 인디케이터 갱신
        vm.$state.map(\.isLoading).removeDuplicates()
            .sink { [weak self] in self?.setLoadingIndicatorVisible($0) }
            .store(in: &cancellables)

        // 상태 전이 중 발생한 에러를 알림으로 표시
        vm.effect.compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
    }

    // MARK: Reactive Interface

    /// 에러 알림 확인 후 참여 흐름 종료 이벤트를 Coordinator에 전달
    var errorAlertDismissedPublisher: AnyPublisher<Void, Never> {
        vm.effect
            .compactMap { $0[case: \.presentErrorWithDismiss] }
            .compactMap { [weak self] in self?.presentDismissibleErrorAlert(error: $0) }
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    /// 서클 참여 완료 이벤트를 Coordinator에 전달
    var joinCircleCompletedPublisher: AnyPublisher<Void, Never> {
        vm.effect
            .compactMap { $0[case: \.joinCircleCompleted] }
            .eraseToAnyPublisher()
    }

    /// 확인 시 완료 이벤트를 전달하는 에러 알림 표시
    private func presentDismissibleErrorAlert(
        error: LocalizedError
    ) -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let alert = NoticeAlertVC()
            alert.titleLabel.text = "문제가 발생했어요"
            alert.descriptionLabel.text = error.errorDescription

            alert.acceptButton.tapPublisher
                .sink { [weak alert] in
                    alert?.dismiss(animated: true) { promise(.success(())) }
                }
                .store(in: &alert.cancellables)

            self?.present(alert, animated: true)
        } }
        .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    let vm = JoinCircleDI.shared.makeJoinConfirmationVM(invitationCode: "TEST")
    return JoinConfirmationVC(vm: vm)
}
