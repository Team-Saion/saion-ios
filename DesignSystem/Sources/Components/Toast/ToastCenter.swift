//
//  ToastCenter.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine

public final class ToastCenter {
    
    // MARK: Singleton
    
    public static let shared = ToastCenter()
    private init() {}
    
    // MARK: Properties
    
    let presentSubject = PassthroughSubject<String, Never>()
    
    // MARK: Methods
    
    public func present(message: String) {
        presentSubject.send(message)
    }
}
