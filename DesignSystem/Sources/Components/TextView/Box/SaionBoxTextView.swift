//
//  SaionBoxTextView.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

public final class SaionBoxTextView: AttributedPlaceholderTextView {

    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: Life Cycle

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDefaults()
        setupBindings()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Defaults

    private func setupDefaults() {
        var placeholderStyle = TextStyle()
        placeholderStyle.typography = .title1Subtle

        var textStyle = TextStyle()
        textStyle.typography = .title1Subtle

        placeholderAttributes = placeholderStyle.toDictionary()
        defaultTextAttributes = textStyle.toDictionary()

        let contentInset = UIEdgeInsets(horizontal: 16, vertical: 14)
        textContainerInset = contentInset
        placeHolderLabel.inset = contentInset
        layer.cornerRadius = Radius.componentXlarge
    }

    // MARK: Bindings

    private func setupBindings() {
        $currentState
            .map { SaionBoxTextFieldAppearance.appearance(for: $0) }
            .removeDuplicates()
            .sink { [weak self] in self?.updateUI(appearance: $0) }
            .store(in: &cancellables)
    }

    // MARK: Reactive Interface

    private func updateUI(appearance: SaionBoxTextFieldAppearance) {
        placeholderAttributes[.foregroundColor] = appearance.placeholderColor
        defaultTextAttributes[.foregroundColor] = appearance.textColor

        backgroundColor = appearance.backgroundColor
        layer.borderColor = appearance.strokeColor.cgColor
        layer.borderWidth = appearance.strokeWidth
    }
}

// MARK: - Preview

#Preview {
    let textView = SaionBoxTextView()
    textView.placeholder = "내용을 입력해주세요."
    return textView
}
