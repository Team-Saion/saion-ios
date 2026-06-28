//
//  LoginVC.swift
//  Saion
//
//  Created by 신정욱 on 6/26/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem

final class LoginVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = AuthDI.shared.makeLoginVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(horizontal: 20))
    
    private let loginButton = {
        let appearance = SaionButton.Appearance(
            size: .xlarge,
            variant: .init(
                foregroundColor: .labelDefault,
                backgroundColor: .hex(0xFFEB00)
            ),
            image: .authKakao,
            imagePlacement: .leading
        )
        
        let button = SaionButton(with: appearance)
        button.title = "카카오로 시작하기"
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .backgroundMuted
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(UISpacer())
        mainVStack.addArrangedSubview(loginButton)
        mainVStack.addArrangedSubview(UISpacer(40))
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        loginButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.kakaoLoginTapped) }
            .store(in: &cancellables)
        
        vm.effectPublisher
            .compactMap { $0[case: \.presentError] }
            .print("🥕")
            .sink { [weak self] _ in }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { LoginVC() }
