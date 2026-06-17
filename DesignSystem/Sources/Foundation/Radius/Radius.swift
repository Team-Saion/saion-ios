//
//  Radius.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/12/26.
//

import Foundation

public enum Radius {
    // Component
    public static var componentXsmall: CGFloat { value(4) }
    public static var componentSmall: CGFloat { value(6) }
    public static var componentMedium: CGFloat { value(8) }
    public static var componentLarge: CGFloat { value(10) }
    public static var componentXlarge: CGFloat { value(12) }
    public static var componentXxlarge: CGFloat { value(16) }
    public static var componentFull: CGFloat { value(999) }
    
    // Container
    public static var containerSmall: CGFloat { value(12) }
    public static var containerMedium: CGFloat { value(16) }
    public static var containerLarge: CGFloat { value(20) }
    public static var containerXlarge: CGFloat { value(24) }
    public static var containerXxlarge: CGFloat { value(28) }
    
    private static func value(_ radius: CGFloat) -> CGFloat {
        UIViewRadiusSwizzler.installIfNeeded()
        return radius
    }
}
