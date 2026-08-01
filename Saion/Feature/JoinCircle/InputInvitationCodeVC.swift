//
//  InputInvitationCodeVC.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class InputInvitationCodeVC: NavigationBarVC {

    // MARK: Properties

    var cancellables = Set<AnyCancellable>()

    // MARK: Components

    /// 서클 참여 흐름을 종료하는 닫기 버튼
    let closeBarButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .xBold.withTintColor(.grey800)
        return button
    }()

    /// 입력 가이드와 초대 코드 필드를 배치하는 상단 스택
    private let topVStack =
    UIStackView(.vertical, alignment: .center, inset: .init(horizontal: 20))
    /// 참여 버튼을 키보드 상단에 배치하는 하단 스택
    private let bottomVStack =
    UIStackView(.vertical, inset: .init(horizontal: 20))

    /// 초대 코드 입력 가이드 레이블
    private let guideLabel = {
        let style = TextStyle(
            typography: .title2,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("참여할 초대 코드를 입력해요")
        return label
    }()

    /// 초대 코드 입력 필드
    private let textField = {
        let field = SaionPlainTextField()
        field.placeholder = "초대 코드"
        return field
    }()

    /// 참여 버튼
    private let submitButton = {
        let appearance = SaionButton.Appearance(size: .xlarge, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "서클 참여하기"
        button.isEnabled = false
        return button
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }

    // MARK: Defaults

    private func setupDefaults() {
        view.backgroundColor = .white
        defaultNavBar.titleLabel.text = "서클 참여하기"
    }

    // MARK: Layout

    private func setupLayout() {
        defaultNavBar.itemsHStack.addArrangedSubview(closeBarButton)
        defaultNavBar.itemsHStack.addArrangedSubview(UISpacer())

        view.addSubview(topVStack)
        view.addSubview(bottomVStack)

        topVStack.addArrangedSubview(UISpacer(68))
        topVStack.addArrangedSubview(guideLabel)
        topVStack.addArrangedSubview(UISpacer(12))
        topVStack.addArrangedSubview(textField)

        bottomVStack.addArrangedSubview(submitButton)
        bottomVStack.addArrangedSubview(UISpacer(16))

        topVStack.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentLayoutGuide)
        }
        bottomVStack.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }

    // MARK: Bindings

    private func setupBindings() {
        // 공백을 제거한 초대 코드의 입력 여부에 따라 참여 버튼 활성화
        textField.textPublisher
            .map { !($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .removeDuplicates()
            .sink { [weak self] in self?.submitButton.isEnabled = $0 }
            .store(in: &cancellables)
    }

    // MARK: Reactive Interface

    /// 참여 버튼 탭 시 공백을 제거한 유효 초대 코드를 전달
    var invitationCodeSubmitPublisher: AnyPublisher<String, Never> {
        submitButton.tapPublisher
            .compactMap { [weak self] in
                self?.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter { !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    // MARK: Overrides

    override func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        // dismiss 중 키보드 레이아웃을 따라가지 않도록 하단 스택의 현재 위치 고정
        view.layoutIfNeeded()
        let bottomOffset = bottomVStack.frame.maxY - view.bounds.maxY
        bottomVStack.snp.remakeConstraints {
            $0.horizontalEdges.equalTo(contentLayoutGuide)
            $0.bottom.equalToSuperview().offset(bottomOffset)
        }
        view.layoutIfNeeded()
        super.dismiss(animated: flag, completion: completion)
    }
}

// MARK: - Preview

#Preview { InputInvitationCodeVC() }
