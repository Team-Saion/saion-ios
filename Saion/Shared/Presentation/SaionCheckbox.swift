//
//  SaionCheckbox.swift
//  Saion
//
//  Created by 신정욱 on 9/17/26.
//

import Combine
import UIKit

import CombineCocoa

import DesignSystem

final class SaionCheckbox: UIButton {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 버튼 표시 텍스트
    /// 값 변경 시 버튼 설정 업데이트 요청
    var title: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        
        config.contentInsets = .zero
        config.imagePadding = 8
        
        config.background.cornerRadius = .zero
        config.cornerStyle = .fixed
        
        configuration = config
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        tapPublisher
            .sink { [weak self] in self?.isSelected.toggle() }
            .store(in: &cancellables)
    }
    
    // MARK: UpdateConfiguration
    
    override func updateConfiguration() {
        guard var configuration else { return }
        
        configuration.image = isSelected ? .checkboxSelected : .checkboxDefault
        
        /// 타이틀 스타일 반영
        var titleStyle = TextStyle(
            typography: .init(
                font: .pretendard(size: 16, weight: .medium),
                lineHeight: 24
            ),
            decoration: .init(foregroundColor: .gray900)
        )
        configuration.attributedTitle = title.map { titleStyle.toAttrStr($0) }
        
        self.configuration = configuration
    }
    
    // MARK: Reactive Interface
    
    /// 선택 상태를 방출하는 퍼블리셔
    var isSelectedPublisher: AnyPublisher<Bool, Never> {
        publisher(for: \.isSelected).eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { SaionCheckbox() }
