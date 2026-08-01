//
//  BackButtonVC.swift
//  Saion
//
//  Created by 신정욱 on 7/2/26.
//

import Combine
import UIKit

import CombineCocoa
import DesignSystem
import Navigation

class BackButtonVC: NavigationBarVC {

    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    /// 뒤로가기 바 버튼
    private let backBarButton = {
        let appearance = SaionIconButton.Appearance(size: .large)
        let button = SaionIconButton(with: appearance)
        button.image = .chevronLeftLarge.withTintColor(.grey800)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        defaultNavBar.itemsHStack.addArrangedSubview(backBarButton)
        defaultNavBar.itemsHStack.addArrangedSubview(UISpacer())
    }

    // MARK: Bindings

    private func setupBindings() {
        backBarButton.tapPublisher
            .sink { [weak self] in self?.navigationController?.popViewController(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { BackButtonVC() }
