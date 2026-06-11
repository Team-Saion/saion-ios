//
//  Colors.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/9/26.
//

import SwiftUI
import UIKit

// MARK: UIColor

// Primitive 컬러는 에셋 카탈로그에 등록되어 있으므로 별도의 프로퍼티로 노출하지 않고 에셋을 직접 사용합니다.
extension UIColor {
    // Primary
    public static let primaryDefault = UIColor(resource: .green500)
    public static let primaryPressed = UIColor(resource: .green700)
    public static let primarySubtle = UIColor(resource: .green50)
    public static let primaryDisabled = UIColor(resource: .grey300)
    
    // Label
    public static let labelDefault = UIColor(resource: .grey900)
    public static let labelStrong = UIColor(resource: .grey800)
    public static let labelSubtle = UIColor(resource: .grey600)
    public static let labelDisabled = UIColor(resource: .grey400)
    
    // Background
    public static let backgroundDefault = UIColor(resource: .common0)
    public static let backgroundSubtle = UIColor(resource: .grey50)
    public static let backgroundMuted = UIColor(resource: .grey100)
    
    // Line
    public static let lineDefault = UIColor(resource: .grey200)
    public static let lineStrong = UIColor(resource: .grey300)
    public static let lineSubtle = UIColor(resource: .grey100)
    
    // Status
    public static let statusPositiveDefault = UIColor(resource: .blue500)
    public static let statusPositiveSubtle = UIColor(resource: .blue50)
    public static let statusCautionaryDefault = UIColor(resource: .orange500)
    public static let statusCautionarySubtle = UIColor(resource: .orange50)
    public static let statusNegativeDefault = UIColor(resource: .red500)
    public static let statusNegativeSubtle = UIColor(resource: .red50)
    
    // Fill
    public static let fillDefault = UIColor(resource: .grey100)
    public static let fillSubtle = UIColor(resource: .grey50)
    public static let fillDisabled = UIColor(resource: .grey200)
    
    // Overlay
    public static let overlayDimmer = UIColor(resource: .opacity28)
    public static let overlayPressed = UIColor(resource: .opacity12)
}

// MARK: Color

// Primitive 컬러는 에셋 카탈로그에 등록되어 있으므로 별도의 프로퍼티로 노출하지 않고 에셋을 직접 사용합니다.
extension Color {
    // Primary
    public static let primaryDefault = Color(.green500)
    public static let primaryPressed = Color(.green700)
    public static let primarySubtle = Color(.green50)
    public static let primaryDisabled = Color(.grey300)
    
    // Label
    public static let labelDefault = Color(.grey900)
    public static let labelStrong = Color(.grey800)
    public static let labelSubtle = Color(.grey600)
    public static let labelDisabled = Color(.grey400)
    
    // Background
    public static let backgroundDefault = Color(.common0)
    public static let backgroundSubtle = Color(.grey50)
    public static let backgroundMuted = Color(.grey100)
    
    // Line
    public static let lineDefault = Color(.grey200)
    public static let lineStrong = Color(.grey300)
    public static let lineSubtle = Color(.grey100)
    
    // Status
    public static let statusPositiveDefault = Color(.blue500)
    public static let statusPositiveSubtle = Color(.blue50)
    public static let statusCautionaryDefault = Color(.orange500)
    public static let statusCautionarySubtle = Color(.orange50)
    public static let statusNegativeDefault = Color(.red500)
    public static let statusNegativeSubtle = Color(.red50)
    
    // Fill
    public static let fillDefault = Color(.grey100)
    public static let fillSubtle = Color(.grey50)
    public static let fillDisabled = Color(.grey200)
    
    // Overlay
    public static let overlayDimmer = Color(.opacity28)
    public static let overlayPressed = Color(.opacity12)
}
