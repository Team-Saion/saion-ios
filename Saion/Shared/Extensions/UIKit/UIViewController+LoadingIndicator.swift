//
//  UIViewController+LoadingIndicator.swift
//  Saion
//
//  Created by 신정욱 on 7/14/26.
//

import UIKit

import SnapKit

import DesignSystem

/// 뷰컨트롤러별 로딩 인디케이터를 저장하기 위한 연관 객체 키
fileprivate nonisolated(unsafe) var loadingIndicatorViewKey: UInt8 = 0

extension UIViewController {
    /// 화면 전체의 터치를 차단하는 로딩 인디케이터 표시 여부를 변경
    /// - Parameter isVisible: `true`면 표시하고, `false`면 숨김
    func setLoadingIndicatorVisible(_ isVisible: Bool) {
        // 숨김 요청에서는 새 인디케이터를 생성하지 않고 기존 인스턴스만 숨김
        guard isVisible else {
            existingLoadingIndicatorView?.setAnimating(false)
            return
        }
        
        // 기존 인디케이터를 재사용하고, 최초 표시라면 새로 생성
        let indicatorView = loadingIndicatorView
        
        // 최초 표시할 때만 루트 뷰 전체를 덮도록 배치
        if indicatorView.superview == nil {
            view.addSubview(indicatorView)
            indicatorView.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
        
        // 다른 서브뷰에 가리지 않도록 최상단으로 올린 후 표시
        view.bringSubviewToFront(indicatorView)
        indicatorView.setAnimating(true)
    }
    
    /// 기존 인디케이터를 반환하고, 없으면 생성해 뷰컨트롤러에 연결
    private var loadingIndicatorView: SaionIndicatorView {
        if let existingLoadingIndicatorView { return existingLoadingIndicatorView }
        
        let indicatorView = SaionIndicatorView()
        objc_setAssociatedObject(
            self,
            &loadingIndicatorViewKey,
            indicatorView,
            .OBJC_ASSOCIATION_RETAIN
        )
        return indicatorView
    }
    
    /// 새 인디케이터를 생성하지 않고 기존 인스턴스만 반환
    private var existingLoadingIndicatorView: SaionIndicatorView? {
        objc_getAssociatedObject(
            self,
            &loadingIndicatorViewKey
        ) as? SaionIndicatorView
    }
}
