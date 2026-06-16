//
//  Fonts.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/11/26.
//

import SwiftUI
import UIKit

extension UIFont {
    /// UIKit용 Pretendard 폰트를 반환
    public static func pretendard(
        size: Typography.FontSize,
        weight: Typography.FontWeight
    ) -> UIFont {
        FontRegistrar.registerFonts()
        return UIFont(name: weight.rawValue, size: size.rawValue)!
    }
}

extension Font {
    /// SwiftUI용 Pretendard 폰트를 반환
    public static func pretendard(
        size: Typography.FontSize,
        weight: Typography.FontWeight
    ) -> Font {
        FontRegistrar.registerFonts()
        return Font.custom(weight.rawValue, size: size.rawValue)
    }
}
