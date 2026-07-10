//
//  CircleInitializationVC.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class CircleInitializationVC: NavigationBarVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: CircleInitializationVM
    
    // MARK: Components
    
    private let topVStack =
    UIStackView(.vertical, alignment: .center, inset: .init(horizontal: 20))
    private let bottomVStack =
    UIStackView(.vertical, inset: .init(horizontal: 20))
    
    /// 서클 입력 가이드 레이블
    private let guideLabel = {
        let style = TextStyle(
            typography: .title2,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr("우리 써클 이름을 정해요")
        return label
    }()
    
    /// 서클 이름 입력 필드
    private let textField = {
        let field = SaionPlainTextField()
        field.placeholder = "써클 이름"
        return field
    }()
    
    /// 서클 이름 텍스트 필드 캡션 레이블 (가이드 레이블)
    private let captionLabel = {
        let style = TextStyle(
            typography: .title3,
            decoration: .init(foregroundColor: .labelSubtle),
            paragraph: .init(alignment: .center)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    /// 제출 버튼
    private let submitButton = {
        let appearance = SaionButton.Appearance(size: .xlarge, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "써클 만들기"
        return button
    }()
    
    // MARK: Life Cycle
    
    init(vm: CircleInitializationVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .white
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(topVStack)
        view.addSubview(bottomVStack)
        
        topVStack.addArrangedSubview(UISpacer(68))
        topVStack.addArrangedSubview(guideLabel)
        topVStack.addArrangedSubview(UISpacer(12))
        topVStack.addArrangedSubview(textField)
        
        bottomVStack.addArrangedSubview(captionLabel)
        bottomVStack.addArrangedSubview(UISpacer(20))
        bottomVStack.addArrangedSubview(submitButton)
        bottomVStack.addArrangedSubview(UISpacer(16))
        
        topVStack.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentLayoutGuide)
        }
        bottomVStack.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 텍스트 필드 텍스트 변경 이벤트 전달 (구독 시 방출되는 초기 값 무시)
        textField.textPublisher.dropFirst()
            .sink { [weak self] in self?.vm.send(.textChanged($0)) }
            .store(in: &cancellables)
        
        // 제출 버튼 탭 이벤트 전달
        submitButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.submitTapped) }
            .store(in: &cancellables)
        
        // 하단 캡션 레이블 텍스트 바인딩
        vm.$state.map(\.captionText)
            .sink { [weak self] in self?.captionLabel.text = $0 }
            .store(in: &cancellables)
        
        // 서클 이름 유효성 에러 상태 바인딩
        vm.$state.map(\.hasValidationError)
            .removeDuplicates()
            .sink { [weak self] in self?.textField.hasError = $0 }
            .store(in: &cancellables)
        
        // 텍스트 필드 상태에 따른 캡션 UI 바인딩
        textField.$currentState
            .sink { [weak self] in self?.updateCaptionUI(textFieldState: $0) }
            .store(in: &cancellables)
        
        // 유효성에 따른 제출 버튼 활성화 바인딩
        vm.$state.map(\.isValidCircleName)
            .removeDuplicates()
            .sink { [weak self] in self?.submitButton.isEnabled = $0 }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    private func updateCaptionUI(textFieldState: TextFieldState) {
        let captionColor: UIColor = switch textFieldState {
        case .error:    .statusNegativeDefault
        default:        .labelSubtle
        }
        captionLabel.textAttributes[.foregroundColor] = captionColor
    }
}
