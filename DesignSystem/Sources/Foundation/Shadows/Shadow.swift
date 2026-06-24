//
//  Shadow.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/16/26.
//

import UIKit

public struct Shadow: Sendable {
    public let shadowColor: UIColor
    public let shadowOpacity: Float
    public let shadowOffset: CGSize
    public let shadowRadius: CGFloat
}

public extension Shadow {
    static let container = Shadow(
        shadowColor: .black,
        shadowOpacity: 0.08,
        shadowOffset: CGSize(width: 0, height: 4),
        shadowRadius: 10
    )

    static let component = Shadow(
        shadowColor: .black,
        shadowOpacity: 0.16,
        shadowOffset: CGSize(width: 0, height: 0),
        shadowRadius: 24
    )
}
