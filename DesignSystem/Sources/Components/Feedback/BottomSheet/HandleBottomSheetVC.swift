//
//  HandleBottomSheetVC.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/1/26.
//

import UIKit

import SnapKit

open class HandleBottomSheetVC: BottomSheetPresentationVC {
    
    // MARK: Components
    
    public let contentLayoutGuide = UILayoutGuide()
    
    private let handleView = {
        let view = UIView()
        view.backgroundColor = .grey200
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        view.snp.makeConstraints { $0.size.equalTo(CGSize(width: 44, height: 4)) }
        return view
    }()
    
    // MARK: Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(handleView)
        view.addLayoutGuide(contentLayoutGuide)
        
        handleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        contentLayoutGuide.snp.makeConstraints {
            $0.top.equalTo(handleView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Preview

#Preview { HandleBottomSheetVC() }
