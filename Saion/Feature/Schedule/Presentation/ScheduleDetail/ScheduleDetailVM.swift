//
//  ScheduleDetailVM.swift
//  Saion
//
//  Created by 신정욱 on 7/18/26.
//

import Combine
import Foundation

import CasePaths

final class ScheduleDetailVM {
    
    // MARK: Types
    
    enum Action {
        /// 화면 진입 후 일정 상세 정보 조회 요청
        case viewDidLoad
        /// 삭제 확인 후 일정 삭제 요청
        case deleteButtonTapped
        /// 확인 토글 버튼 탭
        case confirmToggled
    }
    
    struct State {
        /// 조회한 일정 상세 도메인 정보
        fileprivate var schedule: Schedule?
        /// 일정 상세 화면을 구성하는 뷰 상태
        var vcState: ScheduleDetailVCState? {
            schedule.map { ScheduleDetailVCState($0) }
        }
        /// 현재 사용자의 일정 삭제 권한에 따른 삭제 버튼 숨김 여부
        var deleteButtonHidden: Bool = true
        /// 일정 상세 조회 또는 삭제 요청 진행 여부
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 일정 삭제 완료
        case scheduleDeleted
    }
    
    // MARK: Properties
    
    /// 화면 렌더링에 사용하는 현재 상태
    @Published private(set) var state = State()
    /// 화면 전환이나 알림처럼 일회성으로 처리할 이벤트
    let effect = PassthroughSubject<Effect, Never>()
    
    /// 일정 조회와 작업 요청에 사용할 서클 식별자
    private let circleID: String
    /// 상세 조회와 삭제에 사용할 일정 식별자
    private let scheduleID: String
    /// 일정 상세 조회와 삭제를 처리하는 저장소
    private let scheduleRepo: ScheduleRepo
    /// 내 프로필 조회를 처리하는 저장소
    private let memberRepo: MemberRepo
    
    // MARK: Initializer
    
    init(
        circleID: String,
        scheduleID: String,
        scheduleRepo: ScheduleRepo,
        memberRepo: MemberRepo
    ) {
        self.circleID = circleID
        self.scheduleID = scheduleID
        self.scheduleRepo = scheduleRepo
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

            let memberID = try await memberRepo.fetchMyProfile().memberID

            let schedule = try await scheduleRepo.fetchScheduleDetail(
                circleID: circleID,
                scheduleID: scheduleID
            )

            state.deleteButtonHidden = !(memberID == schedule.creatorID)
            state.schedule = schedule

        case .deleteButtonTapped:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true

            try await scheduleRepo.deleteSchedule(
                circleID: circleID,
                scheduleID: scheduleID
            )
            ChangeTracker.shared.schedulesDidChange()
            effect.send(.scheduleDeleted)
            
        case .confirmToggled:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true

            guard let confirmation = state.schedule?.confirmations.first else { return }

            // 선택 상태에 따라 확인을 등록하거나 기존 확인을 취소합니다.
            if confirmation.isSelected {
                guard let confirmationID = confirmation.confirmationID else { return }

                try await scheduleRepo.setUnconfirmed(
                    circleID: circleID,
                    scheduleID: scheduleID,
                    confirmationID: confirmationID
                )
            } else {
                try await scheduleRepo.setConfirmed(
                    circleID: circleID,
                    scheduleID: scheduleID
                )
            }

            // 확인 ID와 인원수를 서버의 최신 상태로 동기화합니다.
            state.schedule = try await scheduleRepo.fetchScheduleDetail(
                circleID: circleID,
                scheduleID: scheduleID
            )
        }
    }
}
