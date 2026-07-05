//
//  HomeVC.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

import UIKit

import SnapKit

import DesignSystem

final class HomeVC: UIViewController {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let backgroundLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.yellow50.cgColor,
            UIColor.backgroundMuted.cgColor
        ]
        layer.locations = [0.0, 0.5962]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    private let mainVStack = UIStackView(.vertical)
    
    private let navigationBar = HomeNavigationBar()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundLayer.frame = view.bounds
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.layer.addSublayer(backgroundLayer)
        view.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(navigationBar)
        mainVStack.addArrangedSubview(UISpacer())
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { HomeVC() }
