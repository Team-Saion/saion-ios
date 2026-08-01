//
//  ChangeTracker.swift
//  Saion
//
//  Created by 신정욱 on 7/30/26.
//

import Foundation

final class ChangeTracker {
    
    // MARK: Singleton
    
    static let shared = ChangeTracker()
    private init() {}
    
    // MARK: Properties
    
    /// 일정 목록에 영향을 주는 변경 순번
    private(set) var scheduleRevision = 0
    /// 서클 홈 전체에 영향을 주는 변경 순번
    private(set) var circleRevision = 0
    
    // MARK: Methods
    
    /// 일정 변경과 서클 홈 변경을 기록
    func schedulesDidChange() {
        scheduleRevision &+= 1
        circleRevision &+= 1
    }
}
