//
//  MemberListVM.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

import Combine
import Foundation

import CasePaths

final class MemberListVM {
    
    // MARK: Types
    
    enum Action {
        /// 화면 진입 후 구성원 목록 및 내 프로필 조회
        case viewDidLoad
    }
    
    struct State {
        /// 현재 서클의 원본 구성원 요약 목록
        fileprivate var memberSummaries: [MemberSummary] = []
        /// 내 구성원 식별자
        fileprivate var myID: String?
        /// 구성원 목록에 표시할 셀 아이템
        var memberItems: [MemberCellItem] {
            memberSummaries.map {
                var item = MemberCellItem($0)
                if item.memberID == myID { item.name += "(나)"}
                return item
            }
        }
        /// 화면 로딩 표시 여부
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    private let circleID: String
    private let homeRepo: HomeRepo
    private let memberRepo: MemberRepo
    
    // MARK: Initializer
    
    init(
        circleID: String,
        homeRepo: HomeRepo,
        memberRepo: MemberRepo
    ) {
        self.circleID = circleID
        self.homeRepo = homeRepo
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
            
            state.myID = try await memberRepo.fetchMyProfile().memberID
            state.memberSummaries = try await homeRepo.fetchMembers(circleID: circleID)
        }
    }
}
