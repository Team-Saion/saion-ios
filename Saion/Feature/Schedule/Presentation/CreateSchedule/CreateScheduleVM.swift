//
//  CreateScheduleVM.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import Foundation

import CasePaths

final class CreateScheduleVM {
    
    // MARK: Types
    
    enum Action {
        /// 일정 제목 변경됨
        case titleChanged(String?)
        /// 시작 일시 변경됨
        case startAtChanged(Date)
        /// 종료 일시 변경됨
        case endAtChanged(Date)
        /// 확인 응답 필요 여부 변경됨
        case needConfirmChanged(Bool)
        /// 일정 메모 변경됨
        case memoChanged(String?)
        /// 일정 추가 버튼 탭
        case submitTapped
    }
    
    struct State {
        /// 작성 중인 일정 정보
        fileprivate var draft = ScheduleDraft()
        /// 시작 일시
        var startAt: Date { draft.startAt }
        /// 종료 일시
        var endAt: Date { draft.endAt }
        /// 일정 추가 버튼 활성화 여부
        var submitButtonEnabled: Bool { draft.title?.isEmpty == false }
        /// 일정 생성 요청 진행 여부
        var isLoading = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 일정 생성 화면 닫기
        case dismiss
    }
    
    // MARK: Properties
    
    /// 일정 작성 화면 렌더링에 사용하는 현재 상태
    @Published private(set) var state = State()
    /// 화면 전환이나 알림처럼 일회성으로 처리할 이벤트
    let effect = PassthroughSubject<Effect, Never>()
    
    /// 일정 생성에 사용할 서클 식별자
    private let circleID: String
    /// 일정 생성을 처리하는 저장소
    private let scheduleRepo: ScheduleRepo
    
    // MARK: Initializer
    
    init(
        circleID: String,
        scheduleRepo: ScheduleRepo
    ) {
        self.circleID = circleID
        self.scheduleRepo = scheduleRepo
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
        case .titleChanged(let string):
            let trimmed = string?.trimmingCharacters(in: .whitespacesAndNewlines)
            state.draft.title = trimmed?.isEmpty == true ? nil : trimmed
            
        case .startAtChanged(let date):
            state.draft.startAt = date
            state.draft.endAt = max(state.draft.endAt, date)
            
        case .endAtChanged(let date):
            state.draft.endAt = max(date, state.draft.startAt)
            
        case .needConfirmChanged(let bool):
            state.draft.needConfirm = bool
            
        case .memoChanged(let string):
            let trimmed = string?.trimmingCharacters(in: .whitespacesAndNewlines)
            state.draft.memo = trimmed?.isEmpty == true ? nil : trimmed
            
        case .submitTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            // 일정 생성 요청 후 외부로 이벤트 전달, 반환값은 사용하지 않음
            _ = try await scheduleRepo.createSchedule(from: state.draft, circleID)
            ChangeTracker.shared.schedulesDidChange()
            effect.send(.dismiss)
        }
        
#if DEBUG
        print("""
        [state.draft]
        title: \(state.draft.title ?? "nil")
        startAt: \(state.draft.startAt)
        endAt: \(state.draft.endAt)
        needConfirm: \(state.draft.needConfirm)
        memo: \(state.draft.memo ?? "nil")
        """)
#endif
    }
}
