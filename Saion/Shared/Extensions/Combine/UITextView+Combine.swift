//
//  UITextView+Combine.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Combine
import UIKit

extension UITextView {
    /// 작성 시작 퍼블리셔
    public var didBeginEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidBeginEditingNotification,
            object: self
        )
        .map { _ in }
        .eraseToAnyPublisher()
    }
    
    /// 작성 종료 퍼블리셔
    public var didEndEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidEndEditingNotification,
            object: self
        )
        .map { _ in }
        .eraseToAnyPublisher()
    }
}
