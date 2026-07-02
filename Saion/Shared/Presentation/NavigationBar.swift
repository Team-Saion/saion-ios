//
//  NavigationBar.swift
//  Saion
//
//  Created by 신정욱 on 7/2/26.
//

import UIKit

import SnapKit

import DesignSystem
import Navigation

/// 컨테이너 역할의 커스텀 네비게이션 바
final class NavigationBar: BaseNavigationBar {
    
    // MARK: Properties
    
    /// 네비게이션 바의 고정 높이
    override class var height: CGFloat { 52 }
    
    // MARK: Components
    
    /// 네비게이션 바 아이템을 담는 스택뷰
    ///
    /// - Note:
    ///   좌우 영역을 따로 나누지 않고 아이템을 한 스택뷰 안에 담는 구조로,
    ///   필요하면 ``UIView`` 등을 끼워 넣어서 아이템 위치를 조정해야 함!
    let itemsHStack = UIStackView(alignment: .center, inset: .init(horizontal: 8))
    
    /// 제목 레이블
    let titleLabel = {
        let style = TextStyle(
            typography: .title2,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(itemsHStack)
        itemsHStack.addSubview(titleLabel)
        
        itemsHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}
