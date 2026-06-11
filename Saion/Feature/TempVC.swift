//
//  TempVC.swift
//  Saion
//
//  Created by 신정욱 on 6/12/26.
//

import UIKit

import SnapKit

import DesignSystem

final class TempVC: UIViewController {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let label = {
        var typo = Typography.body2
        typo.foregroundColor = .labelStrong
        let label = UILabel()
        label.attributedText = typo.toNSAttributedString("아무말이나 해볼까 해용")
        return label
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(label)
        
        label.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview { TempVC() }
