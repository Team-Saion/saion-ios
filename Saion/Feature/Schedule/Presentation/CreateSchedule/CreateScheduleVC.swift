//
//  CreateScheduleVC.swift
//  Saion
//
//  Created by 신정욱 on 7/9/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class CreateScheduleVC: NavigationBarVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    private let vm: CreateScheduleVM
    
    private lazy var tapGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        return gesture
    }()
    
    // MARK: Components
    
    /// 일정 입력 영역을 담는 스크롤 뷰
    private let scrollView = ResponsiveScrollView()
    /// 일정 입력 컴포넌트를 세로로 배치하는 스택 뷰
    private let contentVStack = UIStackView(.vertical, inset: .init(edges: 20))
    /// 종일 체크박스 배치하는 스택 뷰
    private let isAllDayHStack = UIStackView()
    
    /// 일정 생성 화면 닫기 버튼
    private let closeBarButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .xBold.withTintColor(.gray700)
        return button
    }()
    
    /// 일정 제목 입력 필드
    private let titleTextField = {
        let field = SaionBoxTextField()
        field.placeholder = "일정 이름"
        return field
    }()
    
    /// 일정 시작 및 종료 일시 선택 뷰
    private let periodView = PerioidPickerView()
    
    /// 종일 일정 체크박스
    private let isAllDayCheckbox = {
        let checkbox = SaionCheckbox()
        checkbox.title = "종일 일정"
        return checkbox
    }()
    
    /// 확인 응답 필요 여부 선택 뷰
    private let needConfirmView = NeedConfirmToggleView()
    
    /// 일정 메모 입력 뷰
    private let memoTextView = {
        let textView = SaionBoxTextView()
        textView.placeholder = "메모 (선택 사항)"
        textView.snp.makeConstraints { $0.height.equalTo(96) }
        return textView
    }()
    
    /// 일정 생성 요청 버튼
    private let submitButton = {
        let appearance = SaionButton.Appearance(size: .xlarge, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "일정 추가"
        return button
    }()
    
    // MARK: Life Cycle
    
    init(vm: CreateScheduleVM) {
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
        defaultNavBar.titleLabel.text = "일정 추가"
        view.backgroundColor = .gray100
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        defaultNavBar.itemsHStack.addArrangedSubview(closeBarButton)
        defaultNavBar.itemsHStack.addArrangedSubview(UISpacer())
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        
        contentVStack.addArrangedSubview(titleTextField)
        contentVStack.addArrangedSubview(UISpacer(20))
        contentVStack.addArrangedSubview(periodView)
        contentVStack.addArrangedSubview(UISpacer(12))
        contentVStack.addArrangedSubview(isAllDayHStack)
        contentVStack.addArrangedSubview(UISpacer(32))
//        contentVStack.addArrangedSubview(needConfirmView)
//        contentVStack.addArrangedSubview(UISpacer(32))
        contentVStack.addArrangedSubview(memoTextView)
        contentVStack.addArrangedSubview(UISpacer(32))
        contentVStack.addArrangedSubview(UISpacer())
        contentVStack.addArrangedSubview(submitButton)
        
        isAllDayHStack.addArrangedSubview(isAllDayCheckbox)
        isAllDayHStack.addArrangedSubview(UISpacer())
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        contentVStack.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 일정 제목 변경 이벤트 전달 (구독 시 방출되는 초기 값 무시)
        titleTextField.textPublisher.dropFirst()
            .sink { [weak self] in self?.vm.send(.titleChanged($0)) }
            .store(in: &cancellables)
        
        isAllDayCheckbox.isSelectedPublisher
            .sink { [weak self] in self?.vm.send(.isAllDayChanged($0)) }
            .store(in: &cancellables)
        
        // 시작 일시 변경 이벤트 전달 (구독 시 방출되는 초기 값 무시)
        periodView.startAtPicker.datePublisher.dropFirst()
            .sink { [weak self] in self?.vm.send(.startAtChanged($0)) }
            .store(in: &cancellables)
        
        // 종료 일시 변경 이벤트 전달 (구독 시 방출되는 초기 값 무시)
        periodView.endAtPicker.datePublisher.dropFirst()
            .sink { [weak self] in self?.vm.send(.endAtChanged($0)) }
            .store(in: &cancellables)
        
        // 확인 응답 필요 여부 변경 이벤트 전달
        needConfirmView.toggle.isOnPublisher
            .sink { [weak self] in self?.vm.send(.needConfirmChanged($0)) }
            .store(in: &cancellables)
        
        // 일정 메모 변경 이벤트 전달 (구독 시 방출되는 초기 값 무시)
        memoTextView.textPublisher.dropFirst()
            .sink { [weak self] in self?.vm.send(.memoChanged($0)) }
            .store(in: &cancellables)
        
        // 제출 버튼 탭 이벤트 전달
        submitButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.submitTapped) }
            .store(in: &cancellables)
        
        vm.$state.map(\.isAllDay).removeDuplicates()
            .sink { [weak self] in
                self?.periodView.startAtPicker.datePickerMode =  $0 ? .date : .dateAndTime
                self?.periodView.endAtPicker.datePickerMode =  $0 ? .date : .dateAndTime
            }
            .store(in: &cancellables)
        
        // 시작 일시와 종료 선택 가능 범위 바인딩
        vm.$state.map(\.startAt).removeDuplicates()
            .sink { [weak self] in
                self?.periodView.startAtPicker.date = $0
                self?.periodView.endAtPicker.minimumDate = $0
            }
            .store(in: &cancellables)
        
        // 종료 일시 바인딩
        vm.$state.map(\.endAt).removeDuplicates()
            .sink { [weak self] in self?.periodView.endAtPicker.date = $0 }
            .store(in: &cancellables)
        
        // 제목 입력 여부에 따른 일정 추가 버튼 활성화 바인딩
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
        
        // 일정 생성 완료 및 닫기 버튼 누르면 화면 닫기
        Publishers.Merge(
            vm.effect.compactMap { $0[case: \.dismiss] },
            closeBarButton.tapPublisher
        )
        .sink { [weak self] in self?.dismiss(animated: true) }
        .store(in: &cancellables)
        
        // 빈 화면 탭 시 키보드 숨김
        tapGesture.tapPublisher
            .sink { [weak self] _ in self?.view.endEditing(true) }
            .store(in: &cancellables)
    }
}

// MARK: - PerioidPickerView

private final class PerioidPickerView: UIStackView {
    
    // MARK: Components
    
    /// 시작 일시 컴포넌트를 배치하는 스택 뷰
    private let startAtHStack = UIStackView(alignment: .center)
    /// 종료 일시 컴포넌트를 배치하는 스택 뷰
    private let endAtHStack = UIStackView(alignment: .center)
    
    /// 시작 일시 안내 레이블
    private let startAtLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .gray400)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("시작")
        return label
    }()
    
    /// 종료 일시 안내 레이블
    private let endAtLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .gray400)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("종료")
        return label
    }()
    
    /// 시작 일시 선택 피커
    let startAtPicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .primaryDefault
        return picker
    }()
    
    /// 종료 일시 선택 피커
    let endAtPicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .primaryDefault
        return picker
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 16, vertical: 14)
        axis = .vertical
        spacing = 14
        
        layer.borderColor = UIColor.lineSubtle.cgColor
        layer.borderWidth = 1
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        backgroundColor = .gray0
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(startAtHStack)
        addArrangedSubview(UIDivider(height: 1, color: .gray200))
        addArrangedSubview(endAtHStack)
        
        startAtHStack.addArrangedSubview(startAtLabel)
        startAtHStack.addArrangedSubview(UISpacer())
        startAtHStack.addArrangedSubview(startAtPicker)
        
        endAtHStack.addArrangedSubview(endAtLabel)
        endAtHStack.addArrangedSubview(UISpacer())
        endAtHStack.addArrangedSubview(endAtPicker)
    }
}

// MARK: - NeedConfirmToggleView

private final class NeedConfirmToggleView: UIStackView {
    
    // MARK: Components
    
    /// 확인 응답 필요 여부 안내 레이블
    private let titleLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("확인 응답 필요")
        return label
    }()
    
    /// 확인 응답 필요 여부 선택 토글
    let toggle = UISwitch()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 16)
        alignment = .center
        
        layer.borderColor = UIColor.lineSubtle.cgColor
        layer.borderWidth = 1
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        backgroundColor = .gray0
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(UISpacer())
        addArrangedSubview(toggle)
        
        snp.makeConstraints { $0.height.equalTo(56) }
    }
}

// MARK: - Preview

#Preview {
    let vm = ScheduleDI.shared.makeCreateScheduleVM(circleID: "preview-circle-id")
    return CreateScheduleVC(vm: vm)
}
