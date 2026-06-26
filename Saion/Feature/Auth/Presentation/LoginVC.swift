//
//  LoginVC.swift
//  Saion
//
//  Created by 신정욱 on 6/26/26.
//

import UIKit

import SnapKit

import DesignSystem

final class LoginVC: UIViewController {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(horizontal: 20))
    
    private let loginButton = {
        let appearance = SaionButton.Appearance(
            size: .xlarge,
            variant: .init(
                foregroundColor: .common100,
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
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { LoginVC() }
