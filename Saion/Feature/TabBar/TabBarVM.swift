//
//  TabBarVM.swift
//  Saion
//
//  Created by 신정욱 on 7/28/26.
//

import Combine
import Foundation

import CasePaths

final class TabBarVM {
    
    // MARK: Types
    
    enum Action {
        case viewDidLoad
        case viewControllersDidSet
        case indexChanged(Int)
    }
    
    struct State {
        var selectedIndex: Int?
    }
    
    @CasePathable
    enum Effect {
        case setViewControllers
        case presentToast(String)
        case presentErrorWithLogout(LocalizedError)
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    private let memberRepo: MemberRepo
    
    // MARK: Initializer
    
    init(memberRepo: MemberRepo) {
        self.memberRepo = memberRepo
    }
    
    // MARK: Send
    
    func send(_ action: Action) {
        Task { @MainActor in
            do {
                try await process(action: action)
            } catch let error as LocalizedError {
                effect.send(.presentError(error))
            }
        }
    }
    
    // MARK: Process
    
    private func process(action: Action) async throws {
        switch action {
        case .viewDidLoad:
            guard let myProfile = try? await memberRepo.fetchMyProfile() else {
                throw SaionError(
                    userMessage: "회원 정보를 불러오는 데 문제가 있어 로그아웃했어요.",
                    errorCode: "TBVM-P-0"
                )
            }
            effect.send(.setViewControllers)
            
        case .viewControllersDidSet:
            state.selectedIndex = 0
            
        case .indexChanged(let index):
            // 가입한 서클이 없으면 일정 탭 진입을 차단
            if index == 1, UserSessionStore.shared.currentCircle == nil {
                effect.send(.presentToast("서클에 가입하면 일정을 확인할 수 있어요."))
                return
            }
            state.selectedIndex = 0
        }
    }
}

