//
//  UserSessionStore.swift
//  Saion
//
//  Created by 신정욱 on 7/21/26.
//

import Combine
import Foundation

final class UserSessionStore {

    // MARK: Singleton

    static let shared = UserSessionStore(
        memberRepo: DefaultMemberRepo(),
        circleRepo: DefaultCircleRepo()
    )

    init(
        memberRepo: MemberRepo,
        circleRepo: CircleRepo
    ) {
        self.memberRepo = memberRepo
        self.circleRepo = circleRepo
    }

    // MARK: Properties

    @Published private(set) var myProfile: MyProfile?
    @Published private(set) var joinedCircles: [CircleSummary] = []
    @Published private(set) var currentCircle: CircleSummary?

    private let memberRepo: MemberRepo
    private let circleRepo: CircleRepo

    // MARK: Public Interface

    func startSession() async throws {
        myProfile = try await memberRepo.fetchMyProfile()
        joinedCircles = try await circleRepo.fetchJoinedCircles()
        currentCircle = joinedCircles.first
    }

    func refreshJoinedCircles() async throws {
        let currentCircleID = currentCircle?.circleID
        let joinedCircles = try await circleRepo.fetchJoinedCircles()

        self.joinedCircles = joinedCircles
        currentCircle = currentCircleID.flatMap { id in
            joinedCircles.first { $0.circleID == id }
        } ?? joinedCircles.first
    }

    func endSession() {
        myProfile = nil
        joinedCircles = []
        currentCircle = nil
    }
}
