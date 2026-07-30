//
//  ScheduleListVM.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import Foundation

import CasePaths

final class ScheduleListVM {
    
    // MARK: Types
    
    enum Action {
        /// 현재 서클의 일정 목록 재조회 요청
        case reloadRequested
        /// 노출된 셀 인덱스를 기준으로 다음 페이지 조회 여부 확인
        case cellWillDisplay(index: Int)
        /// 새 일정 생성 화면 진입 요청
        case createScheduleTapped
        /// 일정 상세 화면 진입 요청
        case scheduleTapped(scheduleID: String)
    }
    
    struct State {
        /// 일정 조회 기준이 되는 현재 활동 서클 식별자
        fileprivate var circleID: String? {
            UserSessionStore.shared.currentCircle?.circleID
        }
        /// 페이지네이션 정보와 원본 일정 목록
        fileprivate var schedulesPage: Pagenation<ScheduleSummary>?
        /// 일정 컬렉션뷰에 표시할 아이템 목록
        var scheduleCellItems: [ScheduleCellItem] {
            schedulesPage?.elemets.map(ScheduleCellItem.init) ?? []
        }
        /// 새로고침 또는 다음 페이지 조회 진행 여부
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 새 일정 생성
        case createSchedule
        /// 일정 상세 화면 진입
        case showScheduleDetail(scheduleID: String)
    }
    
    // MARK: Properties
    
    /// 일정 목록 화면 렌더링에 사용하는 현재 상태
    @Published private(set) var state = State()
    /// 화면 전환이나 알림처럼 일회성으로 처리할 이벤트
    let effect = PassthroughSubject<Effect, Never>()
    
    /// 일정 목록 조회와 페이지네이션을 처리하는 저장소
    private let scheduleRepo: ScheduleRepo
    
    // MARK: Initializer
    
    init(scheduleRepo: ScheduleRepo) {
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
        case .reloadRequested:
            guard let circleID = state.circleID,
                  !state.isLoading
            else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            state.schedulesPage = try await scheduleRepo.fetchSchedules(
                circleID: circleID,
                cursor: nil
            )
            
        case .cellWillDisplay(let index):
            // 다음 페이지가 있고 마지막 5개 셀에 진입했을 때만 선조회한다.
            guard let circleID = state.circleID,
                  let currentPage = state.schedulesPage,
                  currentPage.hasNext,
                  index >= currentPage.elemets.count - 5,
                  !state.isLoading
            else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            let nextPage = try await scheduleRepo.fetchSchedules(
                circleID: circleID,
                cursor: currentPage.nextCursor
            )
            
            // 기존 목록 뒤에 새 일정을 붙이고 다음 조회를 위한 커서 정보를 갱신한다.
            state.schedulesPage?.elemets.append(contentsOf: nextPage.elemets)
            state.schedulesPage?.nextCursor = nextPage.nextCursor
            state.schedulesPage?.hasNext = nextPage.hasNext
            
        case .createScheduleTapped:
            effect.send(.createSchedule)

        case .scheduleTapped(let scheduleID):
            effect.send(.showScheduleDetail(scheduleID: scheduleID))
        }
    }
}
