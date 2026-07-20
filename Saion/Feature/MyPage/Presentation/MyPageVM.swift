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
        /// 화면 표시 후 내 프로필 조회
        case viewDidLoad
        /// 로그아웃 버튼 탭
        case logoutTapped
    }
    
    struct State {
        /// 조회한 내 프로필 도메인 정보
        var myProfile: MyProfile?
        /// 프로필 이미지 뷰 상태
        var profileViewState: ProfileImageViewState? {
            myProfile.map { ProfileImageViewState(from: $0) }
        }
        /// 사용자 이름
        var name: String? { myProfile?.nickname }
        /// 프로필 조회 또는 로그아웃 요청 진행 여부
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
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            state.myProfile = try await memberRepo.fetchMyProfile()
            
        case .logoutTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            try await memberRepo.logout()
            AuthManager.shared.store.send(.userDidLogout)
        }
    }
}
