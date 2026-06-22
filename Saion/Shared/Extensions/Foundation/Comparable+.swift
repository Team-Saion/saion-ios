//
//  Comparable+.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

extension Comparable {
    func clamped(_ range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
