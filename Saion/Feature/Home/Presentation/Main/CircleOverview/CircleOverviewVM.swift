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
        /// 서클 홈 정보 재조회 요청
        case reloadRequested
        /// 구성원 초대 링크 발급 요청
        case inviteTapped
        /// 가족에게 전하기 버튼 탭
        case shareTapped
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
        /// 발급된 구성원 초대 링크 열기
        case openInviteURL(URL)
    }
    
    // MARK: Properties
    
    /// 서클 홈 화면 렌더링에 사용하는 현재 상태
    @Published private(set) var state = State()
    /// 화면 전환이나 알림처럼 일회성으로 처리할 이벤트
    let effect = PassthroughSubject<Effect, Never>()
    
    /// 서클 홈 정보 조회를 처리하는 저장소
    private let homeRepo: HomeRepo
    /// 구성원 초대 링크 발급을 처리하는 저장소
    private let invitationRepo: InvitationRepo
    /// 대표 일정 공유 요청을 처리하는 저장소
    private let scheduleRepo: ScheduleRepo
    /// 내 프로필 조회를 처리하는 저장소
    private let memberRepo: MemberRepo
    
    /// 카카오톡 초대 공유 흐름을 구성하는 유스케이스
    private let inviteWithKakaoUC = InviteWithKakaoUC()
    
    // MARK: Initializer
    
    init(
        homeRepo: HomeRepo,
        invitationRepo: InvitationRepo,
        scheduleRepo: ScheduleRepo,
        memberRepo: MemberRepo
    ) {
        self.homeRepo = homeRepo
        self.invitationRepo = invitationRepo
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
        case .reloadRequested:
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            /// 진입 전 가입한 서클이 있음을 보장하므로 강제 언래핑
            let circleID = UserSessionStore.shared.currentCircle!.circleID
            /// 서클 홈 정보 조회
            state.circleHomeInfo = try await homeRepo.fetchCircleHomeInfo(id: circleID)
            
        case .inviteTapped:
            let currentCircle = UserSessionStore.shared.currentCircle!
            let myProfile = try await memberRepo.fetchMyProfile()
            let invitation = try await invitationRepo.issueInvitation(
                cirlceID: currentCircle.circleID
            )
            let url = try await inviteWithKakaoUC.execute(
                invitation: invitation,
                inviterName: myProfile.nickname,
                circleName: currentCircle.name
            )
            effect.send(.openInviteURL(url))

        case .shareTapped:
            guard !state.isLoading,
                  let scheduleID = state.circleHomeInfo?.mainSchedule?.scheduleID
            else { return }
            defer { state.isLoading = false }
            state.isLoading = true

            let circleID = UserSessionStore.shared.currentCircle!.circleID
            try await scheduleRepo.requestFamilyNotification(
                circleID: circleID,
                scheduleID: scheduleID
            )
        }
    }
}
