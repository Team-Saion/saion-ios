//
//  Publisher+FlatMapFirst.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Combine
import Foundation

extension Publisher {
    /// RxSwift의 `flatMapFirst`처럼 동작하는 오퍼레이터,
    /// inner publisher가 실행 중이면 이후 upstream 값은 무시함
    public func flatMapFirst<Inner: Publisher>(
        _ transform: @escaping (Output) -> Inner
    ) -> AnyPublisher<Inner.Output, Failure>
    where Inner.Failure == Failure {
        /// 실행 상태를 보호하는 락
        let lock = NSLock()
        /// 현재 inner publisher 실행 여부
        var isRunning = false
        
        return self
            .filter { _ in
                lock.lock()
                defer { lock.unlock() }
                
                // 현재 실행 중이 아닐 때만 다음 값을 통과
                guard !isRunning else { return false }
                isRunning = true
                return true
            }
            .flatMap { value in
                // 통과된 값으로 inner publisher를 생성
                transform(value)
                    .handleEvents(
                        receiveCompletion: { _ in
                            lock.lock()
                            defer { lock.unlock() }
                            
                            // inner가 완료되면 실행 상태를 해제
                            isRunning = false
                        },
                        receiveCancel: {
                            lock.lock()
                            defer { lock.unlock() }
                            
                            // inner가 취소되면 실행 상태를 해제
                            isRunning = false
                        }
                    )
            }
            .eraseToAnyPublisher()
    }
}
