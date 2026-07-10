//
//  SaionLineTextField.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/9/26.
//

import Combine
import UIKit

import SnapKit

public final class SaionLineTextField: InsetAttributedTextField {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var underlineHeightConstraint: Constraint?
    
    // MARK: Components
    
    private let underline = UIView()
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var placeholderStyle = TextStyle()
        placeholderStyle.typography = .heading1Subtle
        
        var textStyle = TextStyle()
        textStyle.typography = .heading1Subtle
        
        placeholderAttributes = placeholderStyle.toDictionary()
        defaultTextAttributes = textStyle.toDictionary()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(underline)
        
        snp.makeConstraints { $0.height.equalTo(44) }
        
        underline.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            underlineHeightConstraint = $0.height.equalTo(1).constraint
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        $currentState
            .map { SaionLineTextFieldAppearance.appearance(for: $0) }
            .removeDuplicates()
            .sink { [weak self] in self?.updateUI(appearance: $0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    private func updateUI(appearance: SaionLineTextFieldAppearance) {
        placeholderAttributes[.foregroundColor] = appearance.placeholderColor
        defaultTextAttributes[.foregroundColor] = appearance.textColor
        
        underline.backgroundColor = appearance.underlineColor
        underlineHeightConstraint?.update(offset: appearance.underlineWidth)
    }
}

// MARK: - Preview

#Preview {
    let textField = SaionLineTextField()
    textField.placeholder = "아이디를 입력해주세요."
    return textField
}
