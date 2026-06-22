//
//  Publisher+WithLatestFrom.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Combine
import Foundation

extension Publisher {
    /// RxSwift `withLatestFrom` 과 같은 동작
    /// - Parameter other: 최신 값을 가져올 퍼블리셔
    /// - Returns: (self 출력, other 최신 출력)을 원하는 형태로 매핑한 퍼블리셔
    public func withLatestFrom<Other: Publisher, Result>(
        _ other: Other,
        resultSelector: @escaping (Output, Other.Output) -> Result
    ) -> AnyPublisher<Result, Failure> where Other.Failure == Failure {
        
        // 다른 퍼블리셔의 최신 값을 보관할 subject
        let latest = CurrentValueSubject<Other.Output?, Never>(nil)
        
        // other 의 모든 값을 최신으로 저장
        let latestCancellable = other.sink(
            receiveCompletion: { _ in },
            receiveValue: { latest.send($0) }
        )
        
        // self 가 값을 방출할 때마다 최신 값을 붙여서 내보냄
        return self.compactMap { value -> Result? in
            guard let otherValue = latest.value else { return nil }
            return resultSelector(value, otherValue)
        }
        .handleEvents(receiveCancel: {
            latestCancellable.cancel() // 메모리 누수 방지
        })
        .eraseToAnyPublisher()
    }
    
    /// resultSelector를 사용하지 않는 withLatestFrom
    public func withLatestFrom<Other: Publisher>(
        _ other: Other
    ) -> AnyPublisher<Other.Output, Failure> where Other.Failure == Failure {
        
        // 다른 퍼블리셔의 최신 값을 보관할 subject
        let latest = CurrentValueSubject<Other.Output?, Never>(nil)
        
        // other 의 모든 값을 최신으로 저장
        let latestCancellable = other.sink(
            receiveCompletion: { _ in },
            receiveValue: { latest.send($0) }
        )
        
        // self 가 값을 방출할 때마다 최신 값을 붙여서 내보냄
        return self
            .compactMap { _ in latest.value }
            .handleEvents(receiveCancel: {
                latestCancellable.cancel() // 메모리 누수 방지
            })
            .eraseToAnyPublisher()
    }
}
