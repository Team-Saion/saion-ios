//
//  DeleteAccountReasonVC.swift
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
import Navigation

final class DeleteAccountReasonVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyPageDI.shared.makeDeleteAccountReasonVM()
    
    private lazy var tapGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        return gesture
    }()

    // MARK: Components
    
    /// 화면 콘텐츠를 배치하는 수직 스택
    private let mainVStack = UIStackView(.vertical, inset: .init(horizontal: 20))
    
    /// 탈퇴 사유 입력 안내 제목
    private let headerLabel = {
        let style = TextStyle(
            typography: .heading1,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("탈퇴하는 이유를 알려주세요")
        return label
    }()
    
    /// 탈퇴 사유 수집 목적 안내 문구
    private let captionLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelSubtle)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("사이온 서비스 개선에 큰 도움이 될 거예요.")
        return label
    }()
    
    /// 탈퇴 사유 입력란
    private let textView = {
        let textView = SaionBoxTextView()
        textView.placeholder = "탈퇴하는 이유"
        textView.snp.makeConstraints { $0.height.equalTo(96) }
        return textView
    }()
    
    /// 회원 탈퇴 요청 버튼
    private let submitButton = {
        let appearance = SaionButton.Appearance(size: .xlarge, variant: .danger)
        let button = SaionButton(with: appearance)
        button.title = "탈퇴하기"
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
        defaultNavBar.titleLabel.text = "회원 탈퇴"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(UISpacer(20))
        mainVStack.addArrangedSubview(headerLabel)
        mainVStack.addArrangedSubview(UISpacer(8))
        mainVStack.addArrangedSubview(captionLabel)
        mainVStack.addArrangedSubview(UISpacer(40))
        mainVStack.addArrangedSubview(textView)
        mainVStack.addArrangedSubview(UISpacer(20))
        mainVStack.addArrangedSubview(UISpacer())
        mainVStack.addArrangedSubview(submitButton)
        
        mainVStack.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(contentLayoutGuide)
            $0.horizontalEdges.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 탈퇴 사유 변경 이벤트 전달 (구독 시 방출되는 초기 값 무시)
        textView.textPublisher.dropFirst()
            .sink { [weak self] in self?.vm.send(.reasonChanged($0)) }
            .store(in: &cancellables)
        
        // 회원 탈퇴 확인 얼럿에서 승인한 경우 VM에 탈퇴 이벤트 전달
        submitButton.tapPublisher
            .compactMap { [weak self] in self?.presentDeleteAccountConfirmAlert() }
            .switchToLatest()
            .sink { [weak self] in self?.vm.send(.submitTapped) }
            .store(in: &cancellables)
        
        // 탈퇴 사유 입력 여부에 따른 탈퇴 버튼 활성화 바인딩
        vm.$state.map(\.submitButtonEnabled).removeDuplicates()
            .sink { [weak self] in self?.submitButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        // 로딩 상태에 따라 로딩 인디케이터 노출 여부 갱신
        vm.$state.map(\.isLoading).removeDuplicates()
            .sink { [weak self] in self?.setLoadingIndicatorVisible($0) }
            .store(in: &cancellables)
        
        // 상태 전이 중 발생한 에러를 알림으로 표시
        vm.effect.compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
        
        // 빈 화면 탭 시 키보드 숨김
        tapGesture.tapPublisher
            .sink { [weak self] _ in self?.view.endEditing(true) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 회원 탈퇴 확인 얼럿 노출
    private func presentDeleteAccountConfirmAlert() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let alert = ConfirmAlertVC(acceptVariant: .danger)
            alert.titleLabel.text = "정말 탈퇴하시겠어요?"
            alert.acceptButton.title = "탈퇴"
            
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
}

// MARK: - Preview

#Preview { DeleteAccountReasonVC() }
