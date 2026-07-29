//
//  AlertCenter.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/29/26.
//

import Combine
import Foundation

public final class AlertCenter {
    
    // MARK: Types
    
    public enum Action {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Singleton
    
    public static let shared = AlertCenter()
    private init() {}
    
    // MARK: Properties
    
    private let actionSubject = PassthroughSubject<Action, Never>()
    
    // MARK: Reactive Interface
    
    public func send(_ action: Action) {
        actionSubject.send(action)
    }

    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
