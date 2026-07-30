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
        circleRepo: DefaultCircleRepo()
    )

    init(circleRepo: CircleRepo) {
        self.circleRepo = circleRepo
    }

    // MARK: Properties

    @Published private(set) var joinedCircles: [CircleSummary] = []
    @Published private(set) var currentCircle: CircleSummary?

    private let circleRepo: CircleRepo

    // MARK: Public Interface

    func startSession() async throws {
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
        joinedCircles = []
        currentCircle = nil
    }
}
