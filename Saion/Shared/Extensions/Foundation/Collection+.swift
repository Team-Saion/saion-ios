//
//  Collection+.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Foundation

extension Collection {
    subscript (safe i: Index) -> Iterator.Element? {
        self.indices.contains(i) ? self[i] : nil
    }
}
