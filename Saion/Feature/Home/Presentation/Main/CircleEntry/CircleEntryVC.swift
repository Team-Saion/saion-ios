//
//  CircleEntryVC.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

import UIKit

import SnapKit

import DesignSystem

final class CircleEntryVC: UIViewController {
    
    // MARK: Components
    
    private let buttonVStack = UIStackView(.vertical, spacing: 16)
    
    let joinButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "서클 참여하기"
        return button
    }()
    
    let createButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "서클 생성하기"
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(buttonVStack)
        buttonVStack.addArrangedSubview(joinButton)
        buttonVStack.addArrangedSubview(createButton)
        
        buttonVStack.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Preview

#Preview { CircleEntryVC() }
