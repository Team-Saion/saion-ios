//
//  TermsSheetVC.swift
//  Saion
//
//  Created by 신정욱 on 7/1/26.
//

import Combine
import SafariServices
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem

final class TermsSheetVC: HandleBottomSheetVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    private let vm = AuthDI.shared.makeTermsSheetVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(edges: 20))
    private let checkListHStack0 = UIStackView()
    private let checkListHStack1 = UIStackView()
    private let checkListHStack2 = UIStackView()
    private let closeVStack = UIStackView(.vertical, alignment: .center)
    
    /// 만 14세 이상 필수 동의 버튼
    private let ageConfirmationButton =
    CheckListButton(title: "만 14세 이상", isOptional: false)
    
    /// 서비스 이용약관 필수 동의 버튼
    private let termsAgreementButton =
    CheckListButton(title: "서비스 이용약관 동의", isOptional: false)
    
    /// 개인정보 수집 및 이용 필수 동의 버튼
    private let privacyAgreementButton =
    CheckListButton(title: "개인정보수집 및 이용 동의", isOptional: false)
    
    /// 서비스 이용약관 상세 확인 버튼
    private let termsDetailButton = {
        var config = UIButton.Configuration.plain()
        config.image = .authChevronRight
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    /// 개인정보 수집 및 이용 상세 확인 버튼
    private let privacyDetailButton = {
        var config = UIButton.Configuration.plain()
        config.image = .authChevronRight
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    /// 약관 동의 및 다음 단계 진행 버튼
    private let submitButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "동의하고 다음"
        return button
    }()
    
    /// 바텀시트 닫기 버튼
    private let closeButton = {
        let appearance = SaionTextButton.Appearance(size: .medium, variant: .normal)
        let button = SaionTextButton(with: appearance)
        button.title = "닫기"
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(checkListHStack0)
        mainVStack.addArrangedSubview(UISpacer(4))
        mainVStack.addArrangedSubview(checkListHStack1)
        mainVStack.addArrangedSubview(UISpacer(4))
        mainVStack.addArrangedSubview(checkListHStack2)
        mainVStack.addArrangedSubview(UISpacer(20))
        mainVStack.addArrangedSubview(submitButton)
        mainVStack.addArrangedSubview(UISpacer(20))
        mainVStack.addArrangedSubview(closeVStack)
        
        checkListHStack0.addArrangedSubview(ageConfirmationButton)
        checkListHStack0.addArrangedSubview(UISpacer())
        
        checkListHStack1.addArrangedSubview(termsAgreementButton)
        checkListHStack1.addArrangedSubview(UISpacer())
        checkListHStack1.addArrangedSubview(termsDetailButton)
        
        checkListHStack2.addArrangedSubview(privacyAgreementButton)
        checkListHStack2.addArrangedSubview(UISpacer())
        checkListHStack2.addArrangedSubview(privacyDetailButton)
        
        closeVStack.addArrangedSubview(closeButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 만 14세 이상 동의 버튼 탭 이벤트의 뷰모델 전달
        ageConfirmationButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.ageConfirmationTapped) }
            .store(in: &cancellables)
        
        // 서비스 이용약관 동의 버튼 탭 이벤트의 뷰모델 전달
        termsAgreementButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.termsAgreementTapped) }
            .store(in: &cancellables)
        
        // 개인정보 수집 및 이용 동의 버튼 탭 이벤트의 뷰모델 전달
        privacyAgreementButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.privacyAgreementTapped) }
            .store(in: &cancellables)
        
        // 동의하고 다음 버튼 탭 이벤트의 뷰모델 전달
        submitButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.submitTapped) }
            .store(in: &cancellables)
        
        // 만 14세 이상 동의 상태의 버튼 선택 상태 반영
        vm.$state.map(\.ageConfirmed)
            .sink { [weak self] in self?.ageConfirmationButton.isSelected = $0 }
            .store(in: &cancellables)
        
        // 서비스 이용약관 동의 상태의 버튼 선택 상태 반영
        vm.$state.map(\.termsAgreed)
            .sink { [weak self] in self?.termsAgreementButton.isSelected = $0 }
            .store(in: &cancellables)
        
        // 개인정보 수집 및 이용 동의 상태의 버튼 선택 상태 반영
        vm.$state.map(\.privacyAgreed)
            .sink { [weak self] in self?.privacyAgreementButton.isSelected = $0 }
            .store(in: &cancellables)
        
        // 모든 필수 항목 동의 여부에 따른 다음 버튼 활성화 상태 제어
        vm.$state.map(\.allAgreed)
            .sink { [weak self] in self?.submitButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        // 뷰모델 에러 발생 이펙트 수신 시 에러 얼럿 표시
        vm.effect.compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
        
        // 서비스 이용약관 상세 버튼 탭 시 해당 링크 웹페이지 사파리 표시
        termsDetailButton.tapPublisher
            .map { "https://sites.google.com/view/saio-terms-service-v1-0/홈?authuser=8" }
            .sink { [weak self] in self?.openSafari(url: $0) }
            .store(in: &cancellables)
        
        // 개인정보 수집 및 이용 상세 버튼 탭 시 해당 링크 웹페이지 사파리 표시
        privacyDetailButton.tapPublisher
            .map { "https://sites.google.com/view/saio-terms-personalinfo-v1-0/%ED%99%88" }
            .sink { [weak self] in self?.openSafari(url: $0) }
            .store(in: &cancellables)
        
        // 닫기 버튼 선택 시 바텀시트 닫기
        closeButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 주어진 URL을 Safari 뷰 컨트롤러로 열기
    private func openSafari(url: String) {
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true)
    }
    
    /// 약관 동의 완료 퍼블리셔
    /// 뷰모델의 약관 동의 완료 이펙트 수신 시 완료 이벤트 방출
    var termsAgreementCompletedPublisher: AnyPublisher<Void, Never> {
        vm.effect
            .compactMap { $0[case: \.termsAgreementCompleted] }
            .eraseToAnyPublisher()
    }
}

// MARK: - CheckListButton

private final class CheckListButton: UIButton {
    
    // MARK: Properties
    
    /// 타이틀
    private let title: String
    /// 선택 항목 여부
    private let isOptional: Bool
    
    // MARK: Life Cycle
    
    init(title: String, isOptional: Bool) {
        self.title = title
        self.isOptional = isOptional
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        let run1Style = TextStyle(
            typography: .label1,
            decoration: .init(
                foregroundColor: isOptional ? .labelMuted : .labelDefault
            )
        )
        
        let run2Style = TextStyle(
            typography: .label1Subtle,
            decoration: .init(foregroundColor: .labelStrong)
        )
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle =
        run1Style.toAttrStr(isOptional ? "[선택]" : "[필수]") +
        run2Style.toAttrStr(" \(title)")
        
        config.background.backgroundColor = .clear
        config.contentInsets = .init(horizontal: 6)
        config.imagePadding = 8
        
        configuration = config
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        self.snp.makeConstraints { $0.height.equalTo(28) }
    }
    
    override func updateConfiguration() {
        guard var configuration else { return }
        
        configuration.image = isSelected
        ? .authCheck.withTintColor(.primaryStrong)
        : .authCheck.withTintColor(.grey300)
        
        self.configuration = configuration
    }
}
