//
//  MyPageVM.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import Combine
import Foundation

import CasePaths

final class MyPageVM {
    
    // MARK: Types
    
    enum Action {
        /// 로그아웃 버튼 탭
        case logoutTapped
    }
    
    struct State {
        /// 세션에 저장된 내 프로필 도메인 정보
        var myProfile: MyProfile?
        /// 프로필 이미지 뷰 상태
        var profileViewState: ProfileImageViewState? {
            myProfile.map { ProfileImageViewState(from: $0) }
        }
        /// 사용자 이름
        var name: String? { myProfile?.nickname }
        /// 로그아웃 요청 진행 여부
        var isLoading = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let memberRepo: MemberRepo
    
    // MARK: Initializer
    
    init(memberRepo: MemberRepo) {
        self.memberRepo = memberRepo
        setupBindings()
    }

    // MARK: Bindings

    private func setupBindings() {
        UserSessionStore.shared.$myProfile
            .sink { [weak self] in self?.state.myProfile = $0 }
            .store(in: &cancellables)
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
        case .logoutTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            try await memberRepo.logout()
            AuthManager.shared.store.send(.userDidLogout)
        }
    }
}
