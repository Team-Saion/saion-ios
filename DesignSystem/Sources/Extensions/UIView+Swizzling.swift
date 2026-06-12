import UIKit

public extension UIView {
    /// UIView의 layoutSubviews를 스위즐링하여 cornerRadius 제약을 강제하는 함수야.
    /// 앱 초기화 시점(didFinishLaunchingWithOptions 등)에 한 번 호출해야 해.
    static func swizzleLayoutSubviews() {
        swizzle(
            #selector(layoutSubviews),
            #selector(ds_layoutSubviews)
        )
    }
    
    @objc private func ds_layoutSubviews() {
        // 원래의 layoutSubviews 호출
        self.ds_layoutSubviews()
        
        // 성능 우선: 이미 제한 범위 내에 있다면 재할당하지 않도록 제어해
        let currentRadius = layer.cornerRadius
        if currentRadius > 0 {
            let maxRadius = bounds.height / 2
            if currentRadius > maxRadius {
                layer.cornerRadius = maxRadius
            }
        }
    }
    
    /// 주어진 메서드를 스위즐링
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
