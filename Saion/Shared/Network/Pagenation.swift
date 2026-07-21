//
//  Pagenation.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

/// 페이지네이션 결과를 담는 공통 컨테이너
struct Pagenation<Element: Sendable> {
    var elemets: [Element]
    var nextCursor: String?
    var hasNext: Bool
}
