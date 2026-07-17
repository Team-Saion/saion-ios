//
//  CircleOverviewVM.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import Combine
import Foundation

import CasePaths

final class CircleOverviewVM {
    
    // MARK: Types
    
    enum Action {
        /// 화면 초기 로드 완료
        case viewDidLoad
        /// 새로고침 이벤트가 발생함
        case refreshTriggered
        /// 일정 생성 챕
        case createScheduleTapped
    }
    
    struct State {
        /// 서클 홈 화면 구성에 필요한 원본 도메인 정보
        fileprivate var circleHomeInfo: CircleHomeInfo?
        /// 헤더에 표시할 서클 이름
        var circleTitle: String? { circleHomeInfo?.circle.name }
        /// 대시보드 화면을 구성하는 뷰 상태
        var dashboardViewState: HomeDashboardViewState? {
            circleHomeInfo.map(HomeDashboardViewState.init)
        }
        /// 일정 컬렉션뷰에 표시할 아이템 목록
        var schedulesCollectionViewItems: [HomeSchedulesCollectionViewItem] {
            let schedules = circleHomeInfo?.schedules ?? []
            return schedules.isEmpty
            ? [.add]
            : Array(schedules.map { .schedule(ScheduleCellItem($0)) }.prefix(3))
        }
        /// 구성원 컬렉션뷰에 표시할 멤버 및 초대 아이템 목록
        var membersCollectionViewItems: [HomeMembersCollectionViewItem] {
            guard let circleHomeInfo else { return [] }
            let memberItems = circleHomeInfo.members.map {
                HomeMembersCollectionViewItem.member(MemberCellItem($0))
            }
            return circleHomeInfo.canInvite ? memberItems + [.invite] : memberItems
        }
        /// 화면 로딩 표시 여부
        var isLoading: Bool = false
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
    
    private let circleRepo: CircleRepo
    private let homeRepo: HomeRepo
    
    // MARK: Initializer
    
    init(
        circleRepo: CircleRepo,
        homeRepo: HomeRepo
    ) {
        self.circleRepo = circleRepo
        self.homeRepo = homeRepo
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
        case .viewDidLoad, .refreshTriggered:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            let circleID = if let currentCircleID = state.circleHomeInfo?.circle.circleID {
                currentCircleID
            } else {
                // 진입 전 가입한 서클이 있음을 보장하므로 강제 언래핑
                try await circleRepo.fetchJoinedCircles().first!.circleID
            }
            
            let circleHomeInfo = try await homeRepo.fetchCircleHomeInfo(id: circleID)
            state.circleHomeInfo = circleHomeInfo
            
        case .createScheduleTapped:
            guard let circleID = state.circleHomeInfo?.circle.circleID else { return }
            effect.send(.createSchedule(circleID: circleID))
        }
    }
}
