//
//  HomeVC.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

import UIKit

import SnapKit

final class HomeVC: UIViewController {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    let label = {
        let label = UILabel()
        label.text = "홈 화면 입니다."
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .white
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { HomeVC() }
