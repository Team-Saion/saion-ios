//
//  NSAttributedString+.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/22/26.
//

import Foundation

extension NSAttributedString {
    public static func + (
        lhs: NSAttributedString,
        rhs: NSAttributedString
    ) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        mutable.append(lhs)
        mutable.append(rhs)
        return mutable
    }
}
