//
//  ScheduleCell.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import UIKit

import DesignSystem

import SnapKit

final class ScheduleCell: UICollectionViewCell {
    
    // MARK: Components
    
    private let mainHStack = UIStackView(
        alignment: .center,
        spacing: 8,
        inset: .init(vertical: 16) + .init(leading: 16, trailing: 12)
    )
    
    private let titleVStack = UIStackView(
        .vertical,
        alignment: .leading,
        spacing: 2
    )
    
    /// 제목 레이블 (예: "아빠 병원 검진")
    private let titleLabel = {
        let style = TextStyle(
            typography: .title3Strong,
            decoration: .init(foregroundColor: .labelDefault),
            paragraph: .init(lineBreakMode: .byTruncatingTail)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.numberOfLines = 1
        return label
    }()
    
    /// 캡션 레이블 (예: "6월 28일 (토)")
    private let captionLabel = {
        let style = TextStyle(
            typography: .caption1,
            decoration: .init(foregroundColor: .labelSubtle),
            paragraph: .init(lineBreakMode: .byTruncatingTail)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    /// 일정 상태를 표시하는 배지
    private let dDayBadge = DDayBadge(appearance: .init(sizeMetrics: .medium))
    
    private let chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = .chevronRightMedium.withTintColor(.grey400)
        view.contentMode = .center
        return view
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        contentView.backgroundColor = .backgroundDefault
        contentView.layer.cornerRadius = Radius.containerMedium
        contentView.clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainHStack)
        
        mainHStack.addArrangedSubview(titleVStack)
        mainHStack.addArrangedSubview(dDayBadge)
        mainHStack.addArrangedSubview(chevronImageView)
        
        titleVStack.addArrangedSubview(titleLabel)
        titleVStack.addArrangedSubview(captionLabel)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        dDayBadge.setContentCompressionResistancePriority(.required, for: .horizontal)
        chevronImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: Configure
    
    func configure(with item: ScheduleCellItem?) {
        titleLabel.text = item?.title
        captionLabel.text = item?.caption
        dDayBadge.configure(with: item?.badgeState)
    }
}

// MARK: - Presentation Model

struct ScheduleCellItem: Hashable {
    /// 일정 ID
    let scheduleID: String
    /// 일정 제목 (예: "아빠 병원 검진")
    let title: String
    /// 시작 일시 (예: "6월 28일 (토)")
    let caption: String
    /// 일정 상태 배지
    let badgeState: DDayBadgeState
}

extension ScheduleCellItem {
    /// 일정 요약 정보로 셀 아이템 생성
    init(_ schedule: ScheduleSummary) {
        // 시작일과 종료일을 조합해 일정 기간 구성
        let dateFormatter = DateFormatter.seoul
        dateFormatter.dateFormat = "M월 d일 (E)"

        let startDateText = dateFormatter.string(from: schedule.startAt)
        let endDateText = dateFormatter.string(from: schedule.endAt)
        let isSameDay = Calendar.seoul.isDate(
            schedule.startAt,
            inSameDayAs: schedule.endAt
        )

        let caption: String
        if schedule.isAllDay {
            caption = isSameDay
                ? "\(startDateText) · 종일"
                : "\(startDateText) ~ \(endDateText)"
        } else {
            let timeFormatter = DateFormatter.seoul
            timeFormatter.dateFormat = "a h:mm"
            let startTimeText = timeFormatter.string(from: schedule.startAt)
            let endTimeText = timeFormatter.string(from: schedule.endAt)
            caption = isSameDay
                ? "\(startDateText) · \(startTimeText) ~ \(endTimeText)"
                : "\(startDateText) · \(startTimeText) ~ \(endDateText) · \(endTimeText)"
        }
        
        scheduleID = schedule.scheduleID
        title = schedule.title
        self.caption = caption
        badgeState = .init(status: schedule.status)
    }
}

// MARK: - Preview

#Preview {
    let cell = ScheduleCell(frame: .init(x: 0, y: 0, width: 343, height: 76))
    cell.configure(with: .init(
        scheduleID: "0",
        title: "아빠 병원 검진",
        caption: "6월 28일 (토)",
        badgeState: .init(status: .upcoming(dDay: 10))
    ))
    return cell
}
