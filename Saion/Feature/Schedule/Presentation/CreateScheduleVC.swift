//
//  CreateScheduleVC.swift
//  Saion
//
//  Created by 신정욱 on 7/9/26.
//

import UIKit
import Combine

import SnapKit
import CombineCocoa

import DesignSystem
import Navigation

final class CreateScheduleVC: NavigationBarVC {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(edges: 20))
    
    private let closeBarButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .xBold
        return button
    }()
    
    private let nameTextField = {
        let field = SaionBoxTextField()
        field.placeholder = "일정 이름"
        return field
    }()
    
    private let periodView = PerioidPickerView()
    
    private let needConfirmView = NeedConfirmToggleView()
    
    private let descriptionTextView = {
        let textView = SaionBoxTextView()
        textView.placeholder = "일정 설명 추가"
        textView.snp.makeConstraints { $0.height.equalTo(96) }
        return textView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        defaultNavBar.titleLabel.text = "일정 추가"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        defaultNavBar.itemsHStack.addArrangedSubview(closeBarButton)
        defaultNavBar.itemsHStack.addArrangedSubview(UISpacer())
        
        view.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(nameTextField)
        mainVStack.addArrangedSubview(UISpacer(20))
        mainVStack.addArrangedSubview(periodView)
        mainVStack.addArrangedSubview(UISpacer(32))
        mainVStack.addArrangedSubview(needConfirmView)
        mainVStack.addArrangedSubview(UISpacer(32))
        mainVStack.addArrangedSubview(descriptionTextView)
        mainVStack.addArrangedSubview(UISpacer())
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - PerioidPickerView

private final class PerioidPickerView: UIStackView {
    
    // MARK: Components
    
    private let startAtHStack = UIStackView(alignment: .center)
    private let endAtHStack = UIStackView(alignment: .center)
    
    private let startAtDotImageView = {
        let view = UIImageView()
        view.image = .scheduleDotFill
        view.contentMode = .center
        return view
    }()
    
    private let endAtDotImageView = {
        let view = UIImageView()
        view.image = .scheduleDot
        view.contentMode = .center
        return view
    }()
    
    private let startAtLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelMuted)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("시작")
        return label
    }()
    
    private let endAtLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelMuted)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("종료")
        return label
    }()
    
    let startAtPicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .primaryDefault
        return picker
    }()
    
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
        
        layer.cornerRadius = Radius.componentXxlarge
        clipsToBounds = true
        
        backgroundColor = .fillSubtle
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(startAtHStack)
        addArrangedSubview(UIDivider(height: 1, color: .lineSubtle))
        addArrangedSubview(endAtHStack)
        
        startAtHStack.addArrangedSubview(startAtDotImageView)
        startAtHStack.addArrangedSubview(startAtLabel)
        startAtHStack.addArrangedSubview(UISpacer())
        startAtHStack.addArrangedSubview(startAtPicker)
        
        endAtHStack.addArrangedSubview(endAtDotImageView)
        endAtHStack.addArrangedSubview(endAtLabel)
        endAtHStack.addArrangedSubview(UISpacer())
        endAtHStack.addArrangedSubview(endAtPicker)
    }
}

// MARK: - NeedConfirmToggleView

private final class NeedConfirmToggleView: UIStackView {
    
    // MARK: Components
    
    private let titleLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelStrong)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("확인 응답 필요")
        return label
    }()
    
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
        
        layer.cornerRadius = Radius.componentXxlarge
        clipsToBounds = true
        
        backgroundColor = .fillSubtle
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

#Preview { CreateScheduleVC() }
