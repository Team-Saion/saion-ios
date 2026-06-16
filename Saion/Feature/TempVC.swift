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
        var typo = Typography.display2
        typo.foregroundColor = .labelStrong
        let label = UILabel()
        label.attributedText = typo.toNSAttributedString("아무말이나 해볼까 해용")
        return label
    }()
    
    private let testView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = Radius.componentFull
        return view
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
        view.addSubview(testView)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        testView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }

    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview { return TempVC() }
