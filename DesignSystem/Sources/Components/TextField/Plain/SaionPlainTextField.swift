//
//  SaionPlainTextField.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/9/26.
//

import Combine
import UIKit

import SnapKit

public final class SaionPlainTextField: InsetAttributedTextField {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
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
        let paragraphStyle = TextStyle.Paragraph(alignment: .center)
        
        var placeholderStyle = TextStyle()
        placeholderStyle.typography = .heading1
        placeholderStyle.paragraph = paragraphStyle
        
        var textStyle = TextStyle()
        textStyle.typography = .heading1
        textStyle.paragraph = paragraphStyle
        
        placeholderAttributes = placeholderStyle.toDictionary()
        defaultTextAttributes = textStyle.toDictionary()
        
        inset = .init(horizontal: 20)
        backgroundColor = .clear
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        snp.makeConstraints { $0.height.equalTo(39) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        $currentState
            .map { SaionPlainTextFieldAppearance.appearance(for: $0) }
            .removeDuplicates()
            .sink { [weak self] in self?.updateUI(appearance: $0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    private func updateUI(appearance: SaionPlainTextFieldAppearance) {
        placeholderAttributes[.foregroundColor] = appearance.placeholderColor
        defaultTextAttributes[.foregroundColor] = appearance.textColor
    }
}

// MARK: - Preview

#Preview {
    let textField = SaionPlainTextField()
    textField.placeholder = "닉네임"
    return textField
}
