//
//  ScheduleProgressView.swift
//  Saion
//
//  Created by 신정욱 on 7/18/26.
//

import UIKit

import DesignSystem

final class ScheduleProgressView: UIStackView {
    
    // MARK: Components
    
    /// 일정 진행률을 표시하는 진행 바
    private let progressBar = ProgressBar()
    
    /// 진행률 구간별 상태 문구를 표시하는 안내 뷰
    private let progressGuideView = {
        let leadingTextStyle = TextStyle(
            typography: .caption1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let trailingTextStyle = TextStyle(
            typography: .caption1,
            decoration: .init(foregroundColor: .labelMuted)
        )
        let leadingLabel = UILabel()
        leadingLabel.attributedText = leadingTextStyle.toNSAttrStr("여유있어요")
        let trailingLabel = UILabel()
        trailingLabel.attributedText = trailingTextStyle.toNSAttrStr("서두르세요")
        
        let view = UIStackView()
        view.addArrangedSubview(leadingLabel)
        view.addArrangedSubview(UISpacer())
        view.addArrangedSubview(trailingLabel)
        return view
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
        spacing = 8
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(progressBar)
        addArrangedSubview(progressGuideView)
    }
    
    // MARK: Public Method
    
    func setProgress(_ progress: CGFloat) {
        progressBar.setProgress(progress)
    }
}

// MARK: - ProgressBar

private final class ProgressBar: UIView {
    
    // MARK: Properties
    
    private var progress: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 8)
    }
    
    // MARK: Components
    
    /// 진행률만큼 채워지는 그라데이션 뷰
    private let progressFillView = ProgressFillView()
    
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

// MARK: - ProgressFillView

private final class ProgressFillView: UIView {
    
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
