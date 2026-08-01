//
//  Coordinator.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Combine
import UIKit

import Navigation

/// 앱의 네비게이션 흐름을 제어하는 기본 단위
class Coordinator: NSObject {
    
    // MARK: Properties
    
    /// 하위 흐름을 관리하기 위한 자식 코디네이터 참조 배열
    /// - Note: 자식의 생명주기를 유지하기 위해 강한 참조를 보관해야 함
    private var children: [Coordinator] = []
    
    /// 화면 전환을 수행할 내비게이션 컨트롤러
    let navigation: NavigationController
    
    /// 현재 코디네이터가 소유한 Combine 구독 생명주기 보관소
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Subjects
    
    /// 현재 코디네이터의 종료를 부모에게 전달하는 이벤트 스트림
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Life Cycle
    
    init(navigation: NavigationController) {
        print("[\(type(of: self))] 시작")
        self.navigation = navigation
    }
    
    deinit { print("[\(type(of: self))] 종료") }
    
    // MARK: Public Methods
    
    /// 자식 코디네이터를 등록하고 종료 시 배열에서 자동으로 해제
    func addChild(_ child: Coordinator) {
        children.append(child)
        
        // 종료 이벤트를 구독해 부모가 보유한 강한 참조 제거
        child.didFinishSubject
            .sink { [weak self, weak child] in self?.removeChild(child) }
            .store(in: &child.cancellables)
    }
    
    /// 전달받은 자식 코디네이터의 생명주기 관리 종료
    func removeChild(_ child: Coordinator?) { children.removeAll { $0 === child } }
    
    /// 모든 자식 코디네이터의 생명주기 관리 종료
    func removeAllChildren() { children.removeAll() }
    
    /// 부모에게 종료 이벤트를 전달하여 현재 코디네이터의 해제를 요청
    func removeFromParent() { didFinishSubject.send(()) }
}
