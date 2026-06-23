//
//  SaionLineTextForm.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/22/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

public final class SaionLineTextForm: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var constraint: Constraint?
    
    @Published public var hasError: Bool = false
    
    // MARK: Components
    
    public let titleLabel = {
        var style = TextStyle()
        style.typography = .label1Subtle
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    public let textField =  {
        var placeholderStyle = TextStyle()
        placeholderStyle.typography = .heading1Subtle
        
        var textStyle = TextStyle()
        textStyle.typography = .heading1Subtle
        
        var field = InsetAttributedTextField()
        field.placeholderAttributes = placeholderStyle.toDictionary()
        field.defaultTextAttributes = textStyle.toDictionary()
        
        field.snp.makeConstraints { $0.height.equalTo(44) }
        return field
    }()
    
    public let captionLabel = {
        var style = TextStyle()
        style.typography = .label1Subtle
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    private let underline = UIView()
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        axis = .vertical
        spacing = 6
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(textField)
        addArrangedSubview(captionLabel)
        
        textField.addSubview(underline)
        
        underline.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            constraint = $0.height.equalTo(1).constraint
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 텍스트 필드의 포커스(편집 시작 및 종료) 상태
        let isFocused = Publishers
            .Merge(
                textField.controlEventPublisher(for: .editingDidBegin).map { true },
                textField.controlEventPublisher(for: .editingDidEnd).map { false }
            )
            .prepend(textField.isEditing)
            .removeDuplicates()
        
        /// 텍스트 필드의 활성/비활성(isEnabled) 상태
        let isEnabled = textField.publisher(for: \.isEnabled)
            .prepend(textField.isEnabled)
            .removeDuplicates()
        
        /// 텍스트 필드에 글자가 입력되어 있는지 여부
        let isFilled = textField.textPublisher
            .map { $0?.isEmpty == false }
            .prepend(textField.text?.isEmpty == false)
            .removeDuplicates()
        
        /// 에러 발생 여부
        let hasError = $hasError
            .removeDuplicates()
        
        /// 여러 상태를 조합하여 현재 상태에 맞는 UI 스타일(Appearance)을 결정
        let currentAppearance = Publishers
            .CombineLatest4(isEnabled, hasError, isFocused, isFilled)
            .map { isEnabled, hasError, isFocused, isFilled -> TextFormAppearance in
                if !isEnabled { return .disabled }
                if hasError { return .error }
                if isFocused { return .focused }
                if isFilled { return .filled }
                return .normal
            }
            .removeDuplicates()
        
        // 주어진 appearance로 UI 갱신
        currentAppearance
            .sink { [weak self] in self?.updateUI(appearance: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Reactive Interface

extension SaionLineTextForm {
    /// 주어진 appearance로 UI 갱신
    private func updateUI(appearance: TextFormAppearance) {
        titleLabel.textAttributes[.foregroundColor] = appearance.titleColor
        captionLabel.textAttributes[.foregroundColor] = appearance.captionColor
        textField.placeholderAttributes[.foregroundColor] = appearance.placeholderColor
        textField.defaultTextAttributes[.foregroundColor] = appearance.textColor
        
        underline.backgroundColor = appearance.strokeColor
        constraint?.update(offset: appearance.strokeWidth)
    }
}

// MARK: - Preview

#Preview {
    let form = SaionLineTextForm()
    form.titleLabel.text = "아이디"
    form.textField.placeholder = "아이디를 입력해주세요."
    form.captionLabel.text = "캡션이 꼭 노출되어 있어야하나 싶긴 하네요."
    return form
}
