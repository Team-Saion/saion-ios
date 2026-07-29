//
//  ToastCenter.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import Foundation

public final class ToastCenter {
    
    // MARK: Singleton
    
    public static let shared = ToastCenter()
    private init() {}
    
    // MARK: Properties
    
    private let presentSubject = PassthroughSubject<String, Never>()
    
    // MARK: Reactive Interface
    
    public func present(message: String) {
        presentSubject.send(message)
    }

    var presentPublisher: AnyPublisher<String, Never> {
        presentSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
