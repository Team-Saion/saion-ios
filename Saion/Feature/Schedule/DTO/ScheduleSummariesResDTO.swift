//
//  ScheduleSummariesResDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/16/26.
//

import Foundation

/// 일정 목록 조회 응답 DTO
struct ScheduleSummariesResDTO: Decodable {
    /// 일정 요약 목록. startDate ASC → startTime ASC → scheduleId ASC 순서로 정렬됩니다.
    let schedules: [ScheduleSummaryResDTO]
    /// 다음 페이지 커서. 다음 요청의 cursor 파라미터로 전달합니다. hasNext=false이면 null.
    let nextCursor: String?
    /// 다음 페이지 존재 여부. false이면 마지막 페이지입니다.
    /// - example: true
    let hasNext: Bool
    
    // MARK: Mapper
    
    func toDomain() -> Pagenation<ScheduleSummary> {
        Pagenation<ScheduleSummary>(
            elemets: schedules.compactMap { $0.toDomain() },
            nextCursor: nextCursor,
            hasNext: hasNext
        )
    }
}
