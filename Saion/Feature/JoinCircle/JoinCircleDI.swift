//
//  JoinCircleDI.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

final class JoinCircleDI {

    // MARK: Singleton

    static let shared = JoinCircleDI()
    private init() {}

    // MARK: Methods

    func makeJoinConfirmationVM(invitationCode: String) -> JoinConfirmationVM {
        JoinConfirmationVM(
            invitationCode: invitationCode,
            invitationRepo: DefaultInvitationRepo()
        )
    }
}
