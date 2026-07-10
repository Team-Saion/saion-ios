//
//  DefaultTextField.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/3/26.
//

import Combine
import UIKit

import CombineCocoa

open class DefaultTextField: UITextField {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 현재 텍스트 필드 상태
    @Published public private(set) var currentState: TextFieldState = .normal
    
    /// 에러 여부
    @Published public var hasError: Bool = false
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupBindings()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        autocapitalizationType = .none  // 자동 대문자 비활성화
        textContentType = .oneTimeCode  // 강력한 비번 생성 방지
        tintColor = .labelDefault
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 텍스트 필드의 포커스(편집 시작 및 종료) 상태
        let isFocused = Publishers
            .Merge(
                controlEventPublisher(for: .editingDidBegin).map { true },
                controlEventPublisher(for: .editingDidEnd).map { false }
            )
            .prepend(isEditing)
            .removeDuplicates()
        
        /// 텍스트 필드의 활성/비활성(isEnabled) 상태
        let isEnabled = publisher(for: \.isEnabled)
            .prepend(isEnabled)
            .removeDuplicates()
        
        /// 텍스트 필드에 글자가 입력되어 있는지 여부
        let isFilled = textPublisher
            .map { $0?.isEmpty == false }
            .prepend(text?.isEmpty == false)
            .removeDuplicates()
        
        /// 여러 상태를 조합하여 현재 상태 생성
        Publishers.CombineLatest4(isEnabled, $hasError, isFocused, isFilled)
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
