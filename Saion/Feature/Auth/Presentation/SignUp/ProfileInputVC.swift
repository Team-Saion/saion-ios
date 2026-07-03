//
//  ProfileInputVC.swift
//  Saion
//
//  Created by 신정욱 on 7/1/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class ProfileInputVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: ProfileInputVM
    
    // MARK: Components
    
    private let topVStack =
    UIStackView(.vertical, alignment: .center, inset: .init(horizontal: 20))
    private let bottomVStack =
    UIStackView(.vertical, inset: .init(horizontal: 20))
    
    /// 프로필 이미지 뷰
    private let profileImageView = ProfileImageView(size: .large)
    
    /// 닉네임 텍스트 필드
    private let nicknameGuideLabel = {
        let style = TextStyle(
            typography: .title2,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("어떻게 불러드릴까요?")
        return label
    }()
    
    /// 닉네임 입력 필드
    private let nicknameTextField = {
        let text = TextStyle(
            typography: .heading1,
            paragraph: .init(alignment: .center)
        )
        let placeholder = TextStyle(
            typography: .heading1,
            decoration: .init(foregroundColor: .labelMuted),
            paragraph: .init(alignment: .center)
        )
        let field = InsetAttributedTextField()
        field.inset = .init(horizontal: 20, vertical: 4)
        field.defaultTextAttributes = text.toDictionary()
        field.placeholderAttributes = placeholder.toDictionary()
        field.tintColor = .labelDefault
        return field
    }()
    
    /// 닉네임 텍스트 필드 캡션 레이블 (가이드 레이블)
    private let nicknameCaptionLabel = {
        let style = TextStyle(
            typography: .title3,
            paragraph: .init(alignment: .center)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.text = "나중에 언제든 바꿀 수 있어요."
        return label
    }()
    
    /// 제출 버튼
    private let submitButton = {
        let appearance = SaionButton.Appearance(size: .xlarge, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "시작하기"
        return button
    }()
    
    // MARK: Life Cycle
    
    init(vm: ProfileInputVM) {
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
    
    private func setupDefaults() {
        view.backgroundColor = .white
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(topVStack)
        view.addSubview(bottomVStack)
        
        topVStack.addArrangedSubview(UISpacer(24))
        topVStack.addArrangedSubview(profileImageView)
        topVStack.addArrangedSubview(UISpacer(40))
        topVStack.addArrangedSubview(nicknameGuideLabel)
        topVStack.addArrangedSubview(UISpacer(12))
        topVStack.addArrangedSubview(nicknameTextField)
        
        bottomVStack.addArrangedSubview(nicknameCaptionLabel)
        bottomVStack.addArrangedSubview(UISpacer(20))
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
        nicknameTextField.textPublisher
            .sink { [weak self] in self?.vm.send(.nicknameChanged($0)) }
            .store(in: &cancellables)
        
        nicknameTextField.$currentState
            .sink { [weak self] in self?.vm.send(.textFieldStateChanged($0)) }
            .store(in: &cancellables)
        
        submitButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.submitTapped) }
            .store(in: &cancellables)
        
        vm.$state.map(\.profileImageViewState)
            .sink { [weak self] in self?.profileImageView.configure(with: $0) }
            .store(in: &cancellables)
        
        vm.$state.map(\.nicknamePlaceholder)
            .sink { [weak self] in self?.nicknameTextField.placeholder = $0 }
            .store(in: &cancellables)
        
        vm.$state.map(\.nicknameText).prefix(1)
            .sink { [weak self] in self?.nicknameTextField.text = $0 }
            .store(in: &cancellables)
        
        vm.$state.compactMap(\.captionText)
            .sink { [weak self] in self?.nicknameCaptionLabel.text = $0 }
            .store(in: &cancellables)
        
        vm.$state.compactMap(\.appearance)
            .sink { [weak self] in self?.updateUI(appearance: $0) }
            .store(in: &cancellables)
        
        vm.$state.map(\.isValidNickname)
            .removeDuplicates()
            .sink { [weak self] in self?.submitButton.isEnabled = $0 }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    private func updateUI(appearance: NicknameFormAppearance) {
        nicknameTextField.defaultTextAttributes[.foregroundColor] = appearance.textColor
        nicknameCaptionLabel.textAttributes[.foregroundColor] = appearance.captionColor
    }
}

// MARK: - Preview

#Preview {
    let vm = AuthDI.shared.makeProfileInputVM(onboardingInfo: .init(
        nickname: "테스트닉네임",
        profileImageURL: URL(string: "https://k.kakaocdn.net/dn/cowdUw/dJMcahD0KsS/qucGkaKhKVw0f5OsKmvNu0/img_110x110.jpg"),
        avatarColor: .systemBlue
    ))
    return ProfileInputVC(vm: vm)
}

