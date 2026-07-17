//
//  CurrentCircleStore.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import Foundation

/// 현재 활동 중인 서클을 앱 전역에서 공유하고
/// 서클 전환 시 변경 사항을 전달하는 저장소
final class CurrentCircleStore {
    
    // MARK: Singleton
    
    static let shared = CurrentCircleStore()
    private init() {}
    
    // MARK: Properties
    
    /// 현재 활동 중인 서클 ID
    @Published var currentCircleID: String?
}
