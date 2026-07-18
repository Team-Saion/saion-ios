//
//  HomeDashboardView.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import UIKit

import SnapKit

import DesignSystem

final class HomeDashboardView: UIStackView {
    
    // MARK: Components
    
    /// 오늘 날짜를 표시하는 제목 레이블
    private let titleLabel = {
        let style = TextStyle(
            typography: .title1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        
        let formatter = DateFormatter.seoul
        formatter.dateFormat = "M월 d일 (E)"
        label.text = formatter.string(from: Date())
        
        return label
    }()
    
    /// 대시보드 콘텐츠를 담는 세로 스택 뷰
    private let contentVStack = {
        let view = UIStackView(.vertical)
        view.inset = .init(edges: 20)
        view.backgroundColor = .backgroundDefault
        view.layer.cornerRadius = Radius.containerXlarge
        view.clipsToBounds = true
        return view
    }()
    
    /// 초대할 구성원이 없을 때 표시하는 뷰
    private let idleView = IdleView()
    
    private let shceduleView = ScheduleView()
    
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
        inset = .init(horizontal: 20)
        axis = .vertical
        spacing = 10
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(contentVStack)
        
        contentVStack.addArrangedSubview(idleView)
        contentVStack.addArrangedSubview(shceduleView)
    }
    
    // MARK: Configure
    
    func configure(with state: HomeDashboardViewState) {
        idleView.isHidden = true
        shceduleView.isHidden = true
        
        switch state {
        case .idle:
            idleView.isHidden = false
            
        case .schedule(let title, let period, let dDay, let progress):
            shceduleView.titleLabel.text = title
            shceduleView.periodLabel.text = period
            shceduleView.dDayLabel.text = dDay
            shceduleView.progressBar.setProgress(progress)
            shceduleView.isHidden = false
        }
    }
}

// MARK: - IdleView

private final class IdleView: UIStackView {
    
    // MARK: Components
    
    /// 초대 안내 이미지를 표시하는 이미지 뷰
    private let letterImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = .homeLetter
        return view
    }()
    
    /// 가족 초대를 안내하는 설명 레이블
    private let descriptionLabel = {
        let style = TextStyle(
            typography: .title1,
            decoration: .init(foregroundColor: .labelDefault),
            paragraph: .init(alignment: .center)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("써클에 함께할 가족을 초대해주세요")
        return label
    }()
    
    /// 초대장 전송 화면으로 이동하는 버튼
    let sendInviteButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "초대장 보내기"
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        axis = .vertical
        spacing = 16
        
        isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(letterImageView)
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(sendInviteButton)
    }
}

// MARK: - ScheduleView

private final class ScheduleView: UIStackView {
    
    // MARK: Components
    
    /// 일정 제목 레이블
    let titleLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    /// 기간 레이블 (예: "6월 24일 (화) · 오전 12:00~오후 11:00")
    let periodLabel = {
        let style = TextStyle(
            typography: .caption1,
            decoration: .init(foregroundColor: .labelMuted)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    /// 일정까지 남은 날짜를 표시하는 레이블
    let dDayLabel = {
        let style = TextStyle(
            typography: .label1,
            decoration: .init(foregroundColor: .red600)
        )
        let label = InsetAttributedLabel()
        label.inset = .init(horizontal: 8)
        label.textAttributes = style.toDictionary()
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.backgroundColor = .red50
        
        label.snp.makeConstraints { $0.height.equalTo(28) }
        return label
    }()
    
    /// 일정 진행률을 표시하는 진행 바
    let progressBar = ScheduleProgressBar()
    
    /// 진행률 구간별 상태 문구를 표시하는 안내 뷰
    private let progressGuideView = {
        let textStyle1 = TextStyle(
            typography: .caption1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let textStyle2 = TextStyle(
            typography: .caption1,
            decoration: .init(foregroundColor: .labelMuted)
        )
        let label1 = UILabel()
        label1.attributedText = textStyle1.toNSAttrStr("여유있어요")
        let label2 = UILabel()
        label2.attributedText = textStyle2.toNSAttrStr("서두르세요")
        
        let view = UIStackView()
        view.addArrangedSubview(label1)
        view.addArrangedSubview(UISpacer())
        view.addArrangedSubview(label2)
        
        return view
    }()
    
    /// 일정 내용을 가족에게 공유하는 버튼
    let shareButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "가족에게 전하기"
        return button
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
        axis = .vertical
        isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(UISpacer(2))
        addArrangedSubview(periodLabel)
        addArrangedSubview(UISpacer(16))
        addArrangedSubview(progressBar)
        addArrangedSubview(UISpacer(8))
        addArrangedSubview(progressGuideView)
        addArrangedSubview(UISpacer(16))
        addArrangedSubview(shareButton)
        
        addSubview(dDayLabel)
        
        dDayLabel.snp.makeConstraints { $0.top.trailing.equalToSuperview() }
    }
}

// MARK: - ScheduleProgressBar

private final class ScheduleProgressBar: UIView {
    
    // MARK: Properties
    
    private var progress: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 8)
    }
    
    // MARK: Components
    
    /// 진행률만큼 채워지는 그라데이션 뷰
    private let progressFillView = ScheduleProgressFillView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        
        progressFillView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width * progress,
            height: bounds.height
        )
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        backgroundColor = .grey100
        clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() { addSubview(progressFillView) }
    
    // MARK: Public Method
    
    func setProgress(_ progress: CGFloat) {
        self.progress = min(max(progress, 0), 1)
        setNeedsLayout()
    }
}

// MARK: - ScheduleProgressFillView

private final class ScheduleProgressFillView: UIView {
    
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupDefaults() {
        clipsToBounds = true
        gradientLayer.colors = [
            UIColor.orange500.cgColor,
            UIColor.orange100.cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }
}

// MARK: - Presentation Model

enum HomeDashboardViewState: Hashable {
    /// 표시할 대표 일정이 없는 상태
    case idle
    /// 대표 일정의 기간과 진행 정보를 표시하는 상태
    case schedule(
        title: String,
        period: String,
        dDay: String,
        progress: CGFloat
    )
    
    /// 서클 홈 정보의 대표 일정으로 대시보드 상태 생성
    init(_ circleHomeInfo: CircleHomeInfo) {
        // 대표 일정이 없으면 빈 대시보드 표시
        guard let schedule = circleHomeInfo.mainSchedule else {
            self = .idle
            return
        }
        
        // 시작일과 종료일을 조합해 일정 기간 구성
        let dateFormatter = DateFormatter.seoul
        dateFormatter.dateFormat = "M월 d일 (E)"
        
        let startDateText = dateFormatter.string(from: schedule.startAt)
        let endDateText = dateFormatter.string(from: schedule.endAt)
        let isSameDay = Calendar.seoul.isDate(
            schedule.startAt,
            inSameDayAs: schedule.endAt
        )
        let dateText = isSameDay ? startDateText : "\(startDateText)~\(endDateText)"
        
        // 종일 여부에 따라 시간 구간 구성
        let timeText: String
        if schedule.isAllDay {
            timeText = "종일"
        } else {
            let timeFormatter = DateFormatter.seoul
            timeFormatter.dateFormat = "a h:mm"
            let startTimeText = timeFormatter.string(from: schedule.startAt)
            let endTimeText = timeFormatter.string(from: schedule.endAt)
            timeText = "\(startTimeText)~\(endTimeText)"
        }
        
        // 화면 표시에 필요한 값으로 일정 상태 구성
        self = .schedule(
            title: schedule.title,
            period: "\(dateText) · \(timeText)",
            dDay: schedule.dDay.map { "\($0)일 전" } ?? "만료됨",
            progress: CGFloat(schedule.progressRate) / 100
        )
    }
}

// MARK: - Preview

#Preview { HomeDashboardView() }
