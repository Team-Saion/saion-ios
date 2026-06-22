//
//  UIViewController+Combine.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Combine
import UIKit

extension UIViewController {
    /// viewDidLoad 이벤트 퍼블리셔
    public var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidLoadSubject.eraseToAnyPublisher()
    }
    
    /// viewWillAppear 이벤트 퍼블리셔
    public var viewWillAppearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewWillAppearSubject.eraseToAnyPublisher()
    }
    
    /// viewWillLayoutSubviews 이벤트 퍼블리셔
    public var viewWillLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewWillLayoutSubviewsSubject.eraseToAnyPublisher()
    }
    
    /// viewDidLayoutSubviews 이벤트 퍼블리셔
    public var viewDidLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidLayoutSubviewsSubject.eraseToAnyPublisher()
    }
    
    /// viewDidAppear 이벤트 퍼블리셔
    public var viewDidAppearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidAppearSubject.eraseToAnyPublisher()
    }
    
    /// viewWillDisappear 이벤트 퍼블리셔
    public var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewWillDisappearSubject.eraseToAnyPublisher()
    }
    
    /// viewDidDisappear 이벤트 퍼블리셔
    public var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.viewDidDisappearSubject.eraseToAnyPublisher()
    }
    
    /// deinit 이벤트 퍼블리셔
    public var deallocatedPublisher: AnyPublisher<Void, Never> {
        lifecycleStorage.deallocatedSubject.eraseToAnyPublisher()
    }
}

// MARK: - Associated Storage

/// 생명주기 퍼블리셔 저장소의 연관 객체 키
///
/// - Note:
///   메모리 주소값만 포인터로 넘겨줄 뿐, 실행 중에 그 변수의 실제 값을 읽거나 쓰는 용도가 아님.
///   따라서 동시성 검사를 예외 처리함
fileprivate nonisolated(unsafe) var lifecycleStorageKey: UInt8 = 0

extension UIViewController {
    /// 생명주기 이벤트를 발행할 저장소를 반환하고, 없으면 생성해 연결
    private var lifecycleStorage: UIViewControllerLifecycleStorage {
        // 메서드 스위즐링 실행 (전역)
        UIViewControllerLifecycleSwizzler.installIfNeeded()
        
        // 인스턴스에 이미 저장소가 있다면 그것을 사용
        if let existingLifecycleStorage { return existingLifecycleStorage }
        
        // 저장소가 없다면 생성 후 연관 객체로 저장
        let lifecycleStorage = UIViewControllerLifecycleStorage()
        
        objc_setAssociatedObject(
            self,
            &lifecycleStorageKey,
            lifecycleStorage,
            .OBJC_ASSOCIATION_RETAIN
        )
        
        return lifecycleStorage
    }
    
    /// 이미 연결된 생명주기 저장소만 반환
    private var existingLifecycleStorage: UIViewControllerLifecycleStorage? {
        objc_getAssociatedObject(
            self,
            &lifecycleStorageKey
        ) as? UIViewControllerLifecycleStorage
    }
}

// MARK: - Swizzled Lifecycle Methods

// 생명주기 메서드 호출만으로 저장소가 생성되지 않도록,
// publisher를 한 번이라도 사용해 저장소가 준비된 인스턴스에만 이벤트 전달
extension UIViewController {
    @objc dynamic fileprivate func lp_viewDidLoad() {
        lp_viewDidLoad()
        existingLifecycleStorage?.viewDidLoadSubject.send(())
    }
    
    @objc dynamic fileprivate func lp_viewWillAppear(_ animated: Bool) {
        lp_viewWillAppear(animated)
        existingLifecycleStorage?.viewWillAppearSubject.send(())
    }
    
    @objc dynamic fileprivate func lp_viewWillLayoutSubviews() {
        lp_viewWillLayoutSubviews()
        existingLifecycleStorage?.viewWillLayoutSubviewsSubject.send(())
    }
    
    @objc dynamic fileprivate func lp_viewDidLayoutSubviews() {
        lp_viewDidLayoutSubviews()
        existingLifecycleStorage?.viewDidLayoutSubviewsSubject.send(())
    }
    
    @objc dynamic fileprivate func lp_viewDidAppear(_ animated: Bool) {
        lp_viewDidAppear(animated)
        existingLifecycleStorage?.viewDidAppearSubject.send(())
    }
    
    @objc dynamic fileprivate func lp_viewWillDisappear(_ animated: Bool) {
        lp_viewWillDisappear(animated)
        existingLifecycleStorage?.viewWillDisappearSubject.send(())
    }
    
    @objc dynamic fileprivate func lp_viewDidDisappear(_ animated: Bool) {
        lp_viewDidDisappear(animated)
        existingLifecycleStorage?.viewDidDisappearSubject.send(())
    }
}

// MARK: - Lifecycle Storage

/// UIViewController 생명주기 퍼블리셔 저장소
private final class UIViewControllerLifecycleStorage {
    let viewDidLoadSubject              = PassthroughSubject<Void, Never>()
    let viewWillAppearSubject           = PassthroughSubject<Void, Never>()
    let viewWillLayoutSubviewsSubject   = PassthroughSubject<Void, Never>()
    let viewDidLayoutSubviewsSubject    = PassthroughSubject<Void, Never>()
    let viewDidAppearSubject            = PassthroughSubject<Void, Never>()
    let viewWillDisappearSubject        = PassthroughSubject<Void, Never>()
    let viewDidDisappearSubject         = PassthroughSubject<Void, Never>()
    let deallocatedSubject              = PassthroughSubject<Void, Never>()
    
    // UIViewController의 deinit을 직접 감지할 수 없어 저장소 해제 시점에 이벤트 발행
    deinit { deallocatedSubject.send(()) }
}

// MARK: - Lifecycle Swizzler

/// UIViewController 생명주기 메서드 스위즐링
private enum UIViewControllerLifecycleSwizzler {
    /// 같은 스위즐을 여러 번 하지 않도록 막는 플래그
    nonisolated(unsafe) private static var isInstalled = false
    
    /// 뷰컨트롤러 생명주기 메서드 스위즐링
    static func installIfNeeded() {
        guard !isInstalled else { return }
        isInstalled = true
        
        swizzle(
            #selector(UIViewController.viewDidLoad),
            #selector(UIViewController.lp_viewDidLoad)
        )
        swizzle(
            #selector(UIViewController.viewWillAppear(_:)),
            #selector(UIViewController.lp_viewWillAppear(_:))
        )
        swizzle(
            #selector(UIViewController.viewWillLayoutSubviews),
            #selector(UIViewController.lp_viewWillLayoutSubviews)
        )
        swizzle(
            #selector(UIViewController.viewDidLayoutSubviews),
            #selector(UIViewController.lp_viewDidLayoutSubviews)
        )
        swizzle(
            #selector(UIViewController.viewDidAppear(_:)),
            #selector(UIViewController.lp_viewDidAppear(_:))
        )
        swizzle(
            #selector(UIViewController.viewWillDisappear(_:)),
            #selector(UIViewController.lp_viewWillDisappear(_:))
        )
        swizzle(
            #selector(UIViewController.viewDidDisappear(_:)),
            #selector(UIViewController.lp_viewDidDisappear(_:))
        )
    }
    
    /// 주어진 메서드를 스위즐링
    private static func swizzle(
        _ originalSelector: Selector,
        _ swizzledSelector: Selector
    ) {
        guard
            let originalMethod = class_getInstanceMethod(
                UIViewController.self,
                originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                UIViewController.self,
                swizzledSelector
            )
        else { return }
        
        method_exchangeImplementations(
            originalMethod,
            swizzledMethod
        )
    }
}
