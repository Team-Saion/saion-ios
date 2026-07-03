//
//  TermsSheetVC.swift
//  Saion
//
//  Created by 신정욱 on 7/1/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

import DesignSystem

final class TermsSheetVC: HandleBottomSheetVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(edges: 20))
    private let checkListHStack0 = UIStackView()
    private let checkListHStack1 = UIStackView()
    private let checkListHStack2 = UIStackView()
    private let closeVStack = UIStackView(.vertical, alignment: .center)
//    private let checkListHStack3 = UIStackView()
    
    /// 만 14세 이상 필수 동의 버튼
    private let ageConfirmationButton =
    CheckListButton(title: "만 14세 이상", isOptional: false)
    
    /// 서비스 이용약관 필수 동의 버튼
    private let termsAgreementButton =
    CheckListButton(title: "서비스 이용약관 동의", isOptional: false)
    
    /// 개인정보 수집 및 이용 필수 동의 버튼
    private let privacyAgreementButton =
    CheckListButton(title: "개인정보수집 및 이용 동의", isOptional: false)
    
//    /// 마케팅 정보 수신 선택 동의 버튼
//    private let marketingAgreementButton =
//    CheckListButton(title: "마케팅 정보 수신 동의", isOptional: false)
    
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
    
//    /// 마케팅 정보 수신 동의 상세 확인 버튼
//    private let marketingDetailButton = {
//        var config = UIButton.Configuration.plain()
//        config.image = .authChevronRight
//        config.contentInsets = .zero
//        return UIButton(configuration: config)
//    }()
    
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
//        mainVStack.addArrangedSubview(UISpacer(4))
//        mainVStack.addArrangedSubview(checkListHStack3)
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
        
//        checkListHStack3.addArrangedSubview(marketingAgreementButton)
//        checkListHStack3.addArrangedSubview(UISpacer())
//        checkListHStack3.addArrangedSubview(marketingDetailButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 만 14세 이상 동의 여부
        let ageConfirmed = ageConfirmationButton.tapPublisher
            .handleEvents(receiveOutput: { [weak self] in
                self?.ageConfirmationButton.isSelected.toggle()
            })
            .compactMap { [weak self] in
                self?.ageConfirmationButton.isSelected
            }
        
        /// 서비스 이용약관 동의 여부
        let termsAgreed = termsAgreementButton.tapPublisher
            .handleEvents(receiveOutput: { [weak self] in
                self?.termsAgreementButton.isSelected.toggle()
            })
            .compactMap { [weak self] in
                self?.termsAgreementButton.isSelected
            }
        
        /// 개인정보 수집 및 이용 동의 여부
        let privacyAgreed = privacyAgreementButton.tapPublisher
            .handleEvents(receiveOutput: { [weak self] in
                self?.privacyAgreementButton.isSelected.toggle()
            })
            .compactMap { [weak self] in
                self?.privacyAgreementButton.isSelected
            }
        
//        // 마케팅 정보 수신 동의 여부 스트림
//        let marketingAgreed = marketingAgreementButton.tapPublisher
//            .handleEvents(receiveOutput: { [weak self] in
//                self?.marketingAgreementButton.isSelected.toggle()
//            })
//            .compactMap { [weak self] in
//                self?.marketingAgreementButton.isSelected
//            }
        
        // 모든 필수 약관 동의 여부에 따른 다음 버튼 활성화 처리
        Publishers.CombineLatest3(ageConfirmed, termsAgreed, privacyAgreed)
            .map { $0.0 && $0.1 && $0.2 }
            .prepend(false) // 초기값: 버튼 비활성화
            .sink { [weak self] in self?.submitButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        // 닫기 버튼 선택 시 바텀시트 닫기
        closeButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 약관 동의 완료 퍼블리셔
    var submitPublisher: AnyPublisher<Void, Never> {
        submitButton.tapPublisher
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
