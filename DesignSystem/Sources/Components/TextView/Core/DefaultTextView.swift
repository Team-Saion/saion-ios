//
//  DefaultTextView.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import CombineCocoa

open class DefaultTextView: UITextView {
    
    // MARK: Properties
    
    /// 현재 텍스트 뷰 상태
    @Published public private(set) var currentState: TextFieldState = .normal
    
    /// 에러 여부
    @Published public var hasError: Bool = false
    
    /// 활성/비활성 여부
    @Published public var isEnabled: Bool = true {
        didSet {
            isEditable = isEnabled
            isSelectable = isEnabled
            isUserInteractionEnabled = isEnabled
        }
    }
    
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
        autocapitalizationType = .none
        tintColor = .labelDefault
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 텍스트 뷰의 포커스(편집 시작 및 종료) 상태
        let isFocused = Publishers.Merge(
            NotificationCenter.default.publisher(
                for: UITextView.textDidBeginEditingNotification,
                object: self
            ).map { _ in true },
            NotificationCenter.default.publisher(
                for: UITextView.textDidEndEditingNotification,
                object: self
            ).map { _ in false }
        )
            .prepend(isFirstResponder)
            .removeDuplicates()
        
        /// 텍스트 뷰에 글자가 입력되어 있는지 여부
        let isFilled = textPublisher
            .map { $0?.isEmpty == false }
            .prepend(text?.isEmpty == false)
            .removeDuplicates()
        
        /// 여러 상태를 조합하여 현재 상태 생성
        Publishers.CombineLatest4($isEnabled, $hasError, isFocused, isFilled)
            .map { isEnabled, hasError, isFocused, isFilled -> TextFieldState in
                if !isEnabled { return .disabled }
                if hasError { return .error }
                if isFocused { return .focused }
                if isFilled { return .filled }
                return .normal
            }
            .removeDuplicates()
            .assign(to: &$currentState)
    }
}
