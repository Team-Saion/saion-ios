//
//  HomeDI.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

final class HomeDI {
    
    // MARK: Singleton
    
    static let shared = HomeDI()
    private init() {}
    
    // MARK: Methods
    
    func makeCircleOverviewVM(circleID: String) -> CircleOverviewVM {
        CircleOverviewVM(
            circleID: circleID,
            homeRepo: DefaultHomeRepo(),
            invitationRepo: DefaultInvitationRepo(),
            scheduleRepo: DefaultScheduleRepo(),
            memberRepo: DefaultMemberRepo()
        )
    }
    
    func makeCircleInitializationVM() -> CircleInitializationVM {
        CircleInitializationVM(circleRepo: DefaultCircleRepo())
    }
    
    func makeMemberListVM(circleID: String) -> MemberListVM {
        MemberListVM(
            circleID: circleID,
            homeRepo: DefaultHomeRepo(),
            memberRepo: DefaultMemberRepo()
        )
    }
}
