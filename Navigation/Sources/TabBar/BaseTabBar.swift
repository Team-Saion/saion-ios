//
//  BaseTabBar.swift
//  Navigation
//
//  Created by 신정욱 on 5/4/26.
//

import UIKit

open class BaseTabBar: UIView {
    
    // MARK: Properties
    
    /// 탭바의 고정 높이
    open class var height: CGFloat { 1 }
    
    /// 전환 취소 시 복구 기준이 되는 마지막 확정 숨김 상태
    private var currentHidden: Bool = false
    
    // MARK: Components
    
    /// 배경 뷰
    public let backgroundView = UIView()
    
    /// 버튼 등이 배치되는 콘텐츠 뷰
    public let contentView = UIView()
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
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
            
            // 콘텐츠뷰 영역을 상단에 고정하여, 하단 Safe Area가 늘어나도 콘텐츠뷰 높이는 유지됨
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: type(of: self).height)
        ])
    }
    
    // MARK: Public Methods
    
    /// 주어진 탭바 아이템으로 버튼 구성
    open func setItems(_ items: [UITabBarItem]?) {}
    
    /// 탭바의 숨김 상태를 갱신
    func setHidden(
        _ hidden: Bool,
        transitionCoordinator: UIViewControllerTransitionCoordinator?
    ) {
        // 1. 네비게이션 전환이 아니면 현재 요청 상태를 즉시 확정
        guard let transitionCoordinator else {
            transform = hidden
            ? CGAffineTransform(translationX: 0, y: Self.height)
            : CGAffineTransform.identity
            alpha = hidden ? 0 : 1
            
            isUserInteractionEnabled = !hidden
            currentHidden = hidden
            return
        }
        
        // 2. 전환 중에는 터치를 막고, 네비게이션 애니메이션 타이밍에 맞춰 외형만 변경
        isUserInteractionEnabled = false
        
        transitionCoordinator.animate { [weak self] _ in
            self?.transform = hidden
            ? CGAffineTransform(translationX: 0, y: Self.height)
            : CGAffineTransform.identity
            self?.alpha = hidden ? 0 : 1
            
        } completion: { [weak self] context in
            guard let self else { return }
            
            // 3. 전환 취소 여부에 따라 최종 상태를 확정하고, 터치 가능 여부까지 보정
            let finalHidden = context.isCancelled ? currentHidden : hidden
            
            transform = finalHidden
            ? CGAffineTransform(translationX: 0, y: Self.height)
            : CGAffineTransform.identity
            alpha = finalHidden ? 0 : 1
            
            isUserInteractionEnabled = !finalHidden
            currentHidden = finalHidden
        }
    }
}
