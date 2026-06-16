//
//  UIViewRadiusSwizzler.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/16/26.
//

import UIKit

/// UIView의 layoutSubviews를 스위즐링하여 cornerRadius 제약을 강제하는 스위즐러
enum UIViewRadiusSwizzler {
    
    // MARK: Properties
    
    /// 스위즐링 적용 여부를 추적하는 플래그
    nonisolated(unsafe) private static var isInstalled = false
    /// 스위즐링 초기화의 Thread-safety를 보장하기 위한 락
    private static let lock = NSLock()
    
    // MARK: Public Method
    
    /// 스위즐링 실행
    static func installIfNeeded() {
        // 이미 스위즐링이 완료된 경우 조기 반환함
        guard !isInstalled else { return }
        lock.lock()
        defer { lock.unlock() }
        // 동시성 문제를 방지하기 위해 락을 획득한 후 한 번 더 확인
        guard !isInstalled else { return }
        
        swizzle(
            #selector(UIView.layoutSubviews),
            #selector(UIView.ds_radius_layoutSubviews)
        )
        
        // 스위즐링 성공 플래그 설정
        isInstalled = true
    }
    
    // MARK: Private Helper
    
    /// 두 메서드의 구현체를 교환
    private static func swizzle(
        _ originalSelector: Selector,
        _ swizzledSelector: Selector
    ) {
        guard
            let originalMethod = class_getInstanceMethod(
                UIView.self,
                originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                UIView.self,
                swizzledSelector
            )
        else { return }
        
        method_exchangeImplementations(
            originalMethod,
            swizzledMethod
        )
    }
}

// MARK: - Swizzled Methods

extension UIView {
    /// 원본 layoutSubviews와 교환하여 실행할 커스텀 레이아웃 함수
    @objc dynamic fileprivate func ds_radius_layoutSubviews() {
        // 메서드 교환 상태이므로, 이 호출은 원본 layoutSubviews를 실행함
        self.ds_radius_layoutSubviews()
        
        // 현재 설정된 cornerRadius 값을 조회함
        let currentRadius = layer.cornerRadius
        if currentRadius > 0 {
            // cornerRadius가 높이의 절반을 초과할 수 없도록 제한 범위를 설정함
            let maxRadius = bounds.height / 2
            if currentRadius > maxRadius {
                layer.cornerRadius = maxRadius
            }
        }
    }
}
