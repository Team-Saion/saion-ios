//
//  NSAttributedString+.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/16/26.
//

import Foundation

extension NSAttributedString {
    static func + (
        lhs: NSAttributedString,
        rhs: NSAttributedString
    ) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        mutable.append(lhs)
        mutable.append(rhs)
        return mutable
    }
}
