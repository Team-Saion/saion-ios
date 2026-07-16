//
//  AttributedPlaceholderTextView.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/16/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

open class AttributedPlaceholderTextView: DefaultTextView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 기본 텍스트 속성
    open var defaultTextAttributes = [NSAttributedString.Key: Any]() {
        didSet { setAttributedText(with: text) }
    }
    
    /// 기본 플레이스홀더 속성
    open var placeholderAttributes = [NSAttributedString.Key: Any]() {
        didSet { placeHolderLabel.textAttributes = placeholderAttributes }
    }
    
    /// 플레이스홀더 텍스트
    open var placeholder: String? {
        get { placeHolderLabel.text }
        set { placeHolderLabel.text = newValue }
    }
    
    // MARK: Components
    
    public let placeHolderLabel = {
        let label = InsetAttributedLabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        textContainer.lineFragmentPadding = .zero
        textContainerInset = .zero
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints {
            $0.top.horizontalEdges.width.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 텍스트가 입력되면 플레이스홀더 숨김
        textPublisher
            .map { $0?.isEmpty == false }
            .removeDuplicates()
            .assign(to: \.isHidden, on: placeHolderLabel)
            .store(in: &cancellables)
    }
    
    // MARK: Private Helpers
    
    /// 텍스트에 기본 속성을 적용해 attributedText 갱신
    private func setAttributedText(with text: String?) {
        typingAttributes = defaultTextAttributes
        attributedText = text.map {
            NSAttributedString(string: $0, attributes: defaultTextAttributes)
        }
    }
}
