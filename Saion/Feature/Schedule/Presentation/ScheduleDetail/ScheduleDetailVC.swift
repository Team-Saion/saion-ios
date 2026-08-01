//
//  ScheduleDetailVC.swift
//  Saion
//
//  Created by 신정욱 on 7/18/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class ScheduleDetailVC: BackButtonVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    private let vm: ScheduleDetailVM
    
    // MARK: Components
    
    /// 일정 상세 콘텐츠를 세로로 배치하는 메인 스택 뷰
    private let mainVStack = UIStackView(
        .vertical,
        alignment: .leading,
        inset: .init(edges: 20)
    )
    
    /// 일정 상태를 표시하는 배지
    private let dDayBadge = DDayBadge(appearance: .init(sizeMetrics: .large))
    
    /// 배지 바깥으로 흰색 그림자를 표시하는 컨테이너
    private let dDayBadgeContainer = {
        let view = UIView()
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 12
        return view
    }()
    
    /// 일정 제목을 표시하는 레이블
    private let titleLabel = {
        let style = TextStyle(
            typography: .heading1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    /// 일정의 날짜와 시간 범위를 표시하는 레이블
    private let periodLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.numberOfLines = 2
        return label
    }()
    
    /// 일정 진행률과 구간별 상태 문구를 표시하는 뷰
    private let progressView = {
        let view = ScheduleProgressView()
        view.inset = .init(edges: 20)
        
        view.layer.cornerRadius = Radius.componentXlarge
        view.clipsToBounds = true
        view.backgroundColor = .backgroundDefault
        
        return view
    }()
    
    private let confirmToggleButton = ConfirmToggleButton()
    
    /// 일정 메모를 읽기 전용으로 표시하는 텍스트 뷰
    private let memoTextView = MemoTextView()
    
    /// 일정 생성자에게만 노출되는 삭제 버튼
    private let deleteButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .danger)
        let button = SaionButton(with: appearance)
        button.title = "일정 삭제"
        button.isHidden = true
        return button
    }()
    
    // MARK: Life Cycle
    
    init(vm: ScheduleDetailVM) {
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
    
    private func setupDefaults() { view.backgroundColor = .backgroundMuted }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        view.addSubview(deleteButton)
        
        mainVStack.addArrangedSubview(dDayBadgeContainer)
        mainVStack.addArrangedSubview(UISpacer(8))
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(UISpacer(16))
        mainVStack.addArrangedSubview(periodLabel)
        mainVStack.addArrangedSubview(UISpacer(24))
        mainVStack.addArrangedSubview(progressView)
        mainVStack.addArrangedSubview(UISpacer(24))
        mainVStack.addArrangedSubview(memoTextView)
        mainVStack.addArrangedSubview(UISpacer(24))
        mainVStack.addArrangedSubview(confirmToggleButton)
        
        dDayBadgeContainer.addSubview(dDayBadge)
        
        mainVStack.snp.makeConstraints { $0.top.horizontalEdges.equalTo(contentLayoutGuide) }
        dDayBadge.snp.makeConstraints { $0.edges.equalToSuperview() }
        progressView.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(20) }
        memoTextView.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(20) }
        deleteButton.snp.makeConstraints { $0.centerX.bottom.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 바인딩 구성이 끝난 뒤 일정 상세 조회 요청
        vm.send(.viewDidLoad)
        
        confirmToggleButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.confirmToggled) }
            .store(in: &cancellables)
        
        // 삭제 확인 얼럿에서 승인한 경우 VM에 삭제 이벤트 전달
        deleteButton.tapPublisher
            .compactMap { [weak self] in self?.presentConfirmAlert() }
            .switchToLatest()
            .sink { [weak self] in self?.vm.send(.deleteButtonTapped) }
            .store(in: &cancellables)
        
        // 일정 상세 화면 상태를 각 컴포넌트에 반영
        vm.$state.compactMap(\.vcState).removeDuplicates()
            .sink { [weak self] in self?.updateUI(with: $0) }
            .store(in: &cancellables)
        
        // 일정 생성자 여부에 따라 삭제 버튼 노출 상태 갱신
        vm.$state.map(\.deleteButtonHidden).removeDuplicates()
            .sink { [weak self] in self?.deleteButton.isHidden = $0 }
            .store(in: &cancellables)
        
        // 로딩 상태에 따라 로딩 인디케이터 노출 여부 갱신
        vm.$state.map(\.isLoading).removeDuplicates()
            .sink { [weak self] in self?.setLoadingIndicatorVisible($0) }
            .store(in: &cancellables)
        
        // 상태 전이 중 발생한 에러를 알림으로 표시
        vm.effect.compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
        
        // 일정 삭제 완료 시 이전 화면으로 돌아가기
        vm.effect.compactMap { $0[case: \.scheduleDeleted] }
            .sink { [weak self] in self?.navigationController?.popViewController(animated: true) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    private func updateUI(with state: ScheduleDetailVCState) {
        dDayBadge.configure(with: state.badgeState)
        titleLabel.text = state.title
        periodLabel.text = state.periodText
        progressView.setProgress(state.progress)
        memoTextView.configure(with: state.memo)
        confirmToggleButton.title = state.confirmToggleTitle
        confirmToggleButton.isHidden = state.confirmToggleHidden
        confirmToggleButton.isSelected = state.confirmSelected
    }
    
    /// 사용자의 삭제 확인 결과를 한 번 방출하는 퍼블리셔
    private func presentConfirmAlert() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let alert = ConfirmAlertVC(acceptVariant: .danger)
            alert.titleLabel.text = "삭제하면 구성원에게도 사라져요"
            alert.acceptButton.title = "삭제"
            
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
    
}

// MARK: - MemoTextView

private final class MemoTextView: UITextView {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        textContainer.lineFragmentPadding = .zero
        textContainerInset = .init(horizontal: 16, vertical: 12)
        isEditable = false
        
        layer.cornerRadius = Radius.componentXlarge
        clipsToBounds = true
        
        layer.backgroundColor = UIColor.backgroundDefault.cgColor
        tintColor = .labelDefault
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        self.snp.makeConstraints { $0.height.equalTo(96) }
    }
    
    // MARK: Configure
    
    func configure(with memo: String?) {
        let text: String
        let foregroundColor: UIColor
        
        if let memo, !memo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            text = memo
            foregroundColor = .labelStrong
        } else {
            text = "등록된 메모가 없어요"
            foregroundColor = .labelMuted
        }
        
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: foregroundColor)
        )
        attributedText = style.toNSAttrStr(text)
    }
}

// MARK: - ConfirmToggleButton

private final class ConfirmToggleButton: UIButton {
    
    // MARK: Properties
    
    var title: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 38)
    }
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var config = UIButton.Configuration.plain()
        config.background.cornerRadius = Radius.componentMedium
        config.contentInsets = .init(horizontal: 12)
        config.image = .scheduleCheck
        config.imagePadding = 4
        
        configuration = config
    }
    
    // MARK: Overrides
    
    override func updateConfiguration() {
        guard var configuration else { return }
        
        let foregroundColor: UIColor = isSelected ? .labelInverse : .labelStrong
        let backgroundColor: UIColor = isSelected ? .grey800 : .common0
        let strokeColor: UIColor = isSelected ? .clear : .lineSubtle
        
        let style = TextStyle(
            typography: .title3,
            decoration: .init(foregroundColor: foregroundColor)
        )
        configuration.attributedTitle = title.map { style.toAttrStr($0) }
        configuration.background.backgroundColor = backgroundColor
        configuration.background.strokeColor = strokeColor
        configuration.background.strokeWidth = 1
        
        self.configuration = configuration
    }
}

// MARK: - Presentation Model

struct ScheduleDetailVCState: Hashable {
    /// 일정 상태 배지
    let badgeState: DDayBadgeState
    /// 일정 제목
    let title: String
    /// 일정 날짜와 시간 범위
    let periodText: String
    /// 일정 진행률 (0~1)
    let progress: CGFloat
    /// 일정 메모
    let memo: String?
    /// 확인 토글 노출 여부
    let confirmToggleHidden: Bool
    /// 나의 확인 여부
    var confirmSelected: Bool
    /// 확인 버튼 제목
    let confirmToggleTitle: String
    
    /// 일정 상세 정보로 화면 상태 생성
    init(_ schedule: Schedule) {
        let dateFormatter = DateFormatter.seoul
        dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        
        let startDateText = dateFormatter.string(from: schedule.startAt)
        let endDateText = dateFormatter.string(from: schedule.endAt)
        let isSameDay = Calendar.seoul.isDate(
            schedule.startAt,
            inSameDayAs: schedule.endAt
        )
        
        let periodText: String
        if schedule.isAllDay {
            periodText = isSameDay
            ? "\(startDateText) · 종일"
            : "\(startDateText) ~ \(endDateText)"
        } else {
            let timeFormatter = DateFormatter.seoul
            timeFormatter.dateFormat = "a h:mm"
            let startTimeText = timeFormatter.string(from: schedule.startAt)
            let endTimeText = timeFormatter.string(from: schedule.endAt)
            periodText = isSameDay
            ? "\(startDateText) · \(startTimeText) ~ \(endTimeText)"
            : "\(startDateText) · \(startTimeText) ~\n\(endDateText) · \(endTimeText)"
        }
        
        let confirmToggleTitle = {
            let confirmation = schedule.confirmations.first
            let type = confirmation?.type.rawValue ?? "알 수 없음"
            let count = confirmation.map { String($0.count) } ?? ""
            return "\(type) \(count)"
        }()
        
        self.badgeState = .init(status: schedule.status)
        self.title = schedule.title
        self.periodText = periodText
        self.progress = CGFloat(schedule.progressRate) / 100
        self.memo = schedule.memo
        self.confirmToggleHidden = !schedule.needConfirm
        // TODO: 다중 선택 지원 시 nil 여부가 아닌 선택 내용을 기준으로 판단
        self.confirmSelected = schedule.confirmations.first?.isSelected ?? false
        self.confirmToggleTitle = confirmToggleTitle
    }
}
// MARK: - Preview

#Preview {
    let vm = ScheduleDI.shared.makeScheduleDetailVM(
        circleID: "preview-circle-id",
        scheduleID: "preview-schedule-id"
    )
    return ScheduleDetailVC(vm: vm)
}
