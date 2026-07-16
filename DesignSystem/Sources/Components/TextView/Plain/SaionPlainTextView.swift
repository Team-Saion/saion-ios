//
//  SaionPlainTextView.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

public final class SaionPlainTextView: AttributedPlaceholderTextView {

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
        let paragraphStyle = TextStyle.Paragraph(alignment: .center)

        var placeholderStyle = TextStyle()
        placeholderStyle.typography = .heading1
        placeholderStyle.paragraph = paragraphStyle

        var textStyle = TextStyle()
        textStyle.typography = .heading1
        textStyle.paragraph = paragraphStyle

        placeholderAttributes = placeholderStyle.toDictionary()
        defaultTextAttributes = textStyle.toDictionary()

        textContainerInset = .init(horizontal: 20)
        placeHolderLabel.inset = .init(horizontal: 20)
        backgroundColor = .clear
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
    let textView = SaionPlainTextView()
    textView.placeholder = "내용을 입력해주세요."
    return textView
}
