//
//  CircleSummaryResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import Foundation

/// 서클 요약 응답 DTO
struct CircleSummaryResDTO: Decodable {
    /// 써클 ID
    let circleId: String
    /// 써클 이름
    let name: String
    /// 써클 소유자 ID
    let ownerId: String
}

// MARK: - Mapper

extension CircleSummaryResDTO {
    func toDomain() -> CircleSummary {
        CircleSummary(
            circleID: circleId,
            name: name,
            ownerID: ownerId
        )
    }
}

extension Array where Element == CircleSummaryResDTO {
    func toDomains() -> [CircleSummary] {
        map { $0.toDomain() }
    }
}
