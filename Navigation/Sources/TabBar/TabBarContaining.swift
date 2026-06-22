//
//  TabBarContaining.swift
//  Navigation
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 앱 탭바를 구현한 탭바 컨트롤러 타입 프로토콜
protocol TabBarContaining: UITabBarController {
    
    associatedtype TabBar: BaseTabBar
    
    /// 시스템 탭바의 제약을 피하고 자유로운 구현을 위해 커스텀 객체 사용
    var defaultTabBar: TabBar { get }
}
