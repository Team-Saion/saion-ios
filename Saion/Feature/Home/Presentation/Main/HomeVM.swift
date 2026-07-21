//
//  HomeVM.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

import Combine
import Foundation

import CasePaths

final class HomeVM {
    
    // MARK: Types
    
    enum Action {
        /// 화면 초기 로드 완료
        case viewDidLoad
        /// 새로고침 이벤트가 발생함
        case refreshTriggered
    }
    
    struct State {
        /// 현재 콘텐츠 뷰컨
        var content: HomeContent?
        /// 네트워킹 상태
        var isLoading = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    private let effect = PassthroughSubject<Effect, Never>()
    
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
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            try await UserSessionStore.shared.startSession()
            state.content = UserSessionStore.shared.joinedCircles.isEmpty ? .entry : .overview

        case .refreshTriggered:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true

            try await UserSessionStore.shared.refreshJoinedCircles()
            state.content = UserSessionStore.shared.joinedCircles.isEmpty ? .entry : .overview
        }
    }
}
