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
        /// 화면 초기 로드 완료
        case viewDidLoad
        /// 새로고침 이벤트가 발생함
        case refreshTriggered
        /// 셀 노출
        case cellWillDisplay(index: Int)
        /// 일정 생성 탭
        case createScheduleTapped
    }
    
    struct State {
        fileprivate var circleID: String? {
            CurrentCircleStore.shared.currentCircleID
        }
        fileprivate var schedulesPage: Pagenation<ScheduleSummary>?
        /// 일정 컬렉션뷰에 표시할 아이템 목록
        var scheduleCellItems: [ScheduleCellItem] {
            schedulesPage?.elemets.map(ScheduleCellItem.init) ?? []
        }
        /// 화면 로딩 표시 여부
        var isLoading: Bool = false
        /// 화면 로드 여부
        fileprivate var viewDidLoad: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 새 일정 생성
        case createSchedule(circleID: String)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let scheduleRepo: ScheduleRepo
    
    // MARK: Initializer
    
    init(scheduleRepo: ScheduleRepo) {
        self.scheduleRepo = scheduleRepo
        setupBindings()
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 현재 활동중인 서클 변경시, 새로고침
        CurrentCircleStore.shared.$currentCircleID.removeDuplicates()
            .sink { [weak self] _ in self?.send(.refreshTriggered) }
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
        case .viewDidLoad:
            guard let circleID = state.circleID else { return }
            state.viewDidLoad = true
            
            state.schedulesPage = try await scheduleRepo.fetchSchedules(
                circleID: circleID,
                cursor: nil
            )
            
            
        case .refreshTriggered:
            guard let circleID = state.circleID,
                  state.viewDidLoad,
                  !state.isLoading
            else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            state.schedulesPage = try await scheduleRepo.fetchSchedules(
                circleID: circleID,
                cursor: nil
            )
            
        case .cellWillDisplay(let index):
            // 1. 다음 페이지 존재 여부, 2. 마지막 5개 셀 진입 여부, 3. 중복 패치 방지 체크
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
            
            state.schedulesPage?.elemets.append(contentsOf: nextPage.elemets)
            state.schedulesPage?.nextCursor = nextPage.nextCursor
            state.schedulesPage?.hasNext = nextPage.hasNext
            
        case .createScheduleTapped:
            guard let circleID = state.circleID else { return }
            effect.send(.createSchedule(circleID: circleID))
        }
    }
}
