//
//  UIColor+.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import UIKit

extension UIColor {
    static func hex(_ hex: Int, alpha: CGFloat = 1.0) -> Self {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xff) >> 0) / 255.0
        return .init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
