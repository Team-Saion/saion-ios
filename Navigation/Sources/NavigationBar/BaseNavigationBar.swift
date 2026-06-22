//
//  BaseNavigationBar.swift
//  Navigation
//
//  Created by 신정욱 on 5/4/26.
//

import UIKit

open class BaseNavigationBar: UIView {
    
    // MARK: Properties
    
    /// 네비게이션 바의 고정 높이
    open class var height: CGFloat { 1 }
    
    // MARK: Components
    
    /// 배경 뷰
    public let backgroundView = UIView()
    
    /// 바 아이템 등이 배치되는 콘텐츠 뷰
    public let contentView = UIView()
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(backgroundView)
        addSubview(contentView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 실제 아이템바 영역을 하단에 고정하여, 상단 Safe Area가 늘어나도 아이템바 영역 높이는 유지됨
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: Self.height)
        ])
    }
}
