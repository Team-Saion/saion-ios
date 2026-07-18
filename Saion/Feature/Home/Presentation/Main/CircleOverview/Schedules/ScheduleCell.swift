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
            decoration: .init(foregroundColor: .labelSubtle)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    /// 디데이 레이블 (예: "10일 전")
    private let dDayLabel = {
        let style = TextStyle(
            typography: .label2,
            decoration: .init(foregroundColor: .labelSubtle)
        )
        let label = InsetAttributedLabel()
        label.textAttributes = style.toDictionary()
        label.inset = .init(horizontal: 6)
        
        label.layer.cornerRadius = 23 / 2
        label.clipsToBounds = true
        
        label.backgroundColor = .grey100
        
        label.snp.makeConstraints { $0.height.equalTo(23) }
        return label
    }()
    
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
        mainHStack.addArrangedSubview(dDayLabel)
        mainHStack.addArrangedSubview(chevronImageView)
        
        titleVStack.addArrangedSubview(titleLabel)
        titleVStack.addArrangedSubview(captionLabel)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        dDayLabel.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        chevronImageView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
    }
    
    // MARK: Configure
    
    func configure(with item: ScheduleCellItem?) {
        titleLabel.text = item?.title
        captionLabel.text = item?.caption
        dDayLabel.text = item?.dDay
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
    /// 시작일까지 남은 일수 (예: "10일 전", 경과 시 "만료됨")
    let dDay: String
}

extension ScheduleCellItem {
    /// 일정 요약 정보로 셀 아이템 생성
    init(_ schedule: ScheduleSummary) {
        // 시작 일시를 사용자에게 표시할 날짜 형식으로 변환
        let dateFormatter = DateFormatter.seoul
        dateFormatter.dateFormat = "M월 d일 (E)"
        
        scheduleID = schedule.scheduleID
        title = schedule.title
        caption = dateFormatter.string(from: schedule.startAt)
        dDay = schedule.dDay.map { "\($0)일 전" } ?? "만료됨"
    }
}

// MARK: - Preview

#Preview {
    let cell = ScheduleCell(frame: .init(x: 0, y: 0, width: 343, height: 76))
    cell.configure(with: .init(
        scheduleID: "0",
        title: "아빠 병원 검진",
        caption: "6월 28일 (토)",
        dDay: "10일 전"
    ))
    return cell
}
