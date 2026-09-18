//
//  Colors.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/9/26.
//

import SwiftUI
import UIKit

// MARK: UIColor

// Primitive 컬러들도 외부 모듈에서 직접 접근할 수 있도록 public static 프로퍼티로 제공합니다.
extension UIColor {
    // MARK: - Primitive Colors

    // Green
    public static let green50 = UIColor(resource: .green50)
    public static let green100 = UIColor(resource: .green100)
    public static let green200 = UIColor(resource: .green200)
    public static let green300 = UIColor(resource: .green300)
    public static let green400 = UIColor(resource: .green400)
    public static let green500 = UIColor(resource: .green500)
    public static let green600 = UIColor(resource: .green600)
    public static let green700 = UIColor(resource: .green700)
    public static let green800 = UIColor(resource: .green800)
    public static let green900 = UIColor(resource: .green900)

    // Blue
    public static let blue50 = UIColor(resource: .blue50)
    public static let blue100 = UIColor(resource: .blue100)
    public static let blue200 = UIColor(resource: .blue200)
    public static let blue300 = UIColor(resource: .blue300)
    public static let blue400 = UIColor(resource: .blue400)
    public static let blue500 = UIColor(resource: .blue500)
    public static let blue600 = UIColor(resource: .blue600)
    public static let blue700 = UIColor(resource: .blue700)
    public static let blue800 = UIColor(resource: .blue800)
    public static let blue900 = UIColor(resource: .blue900)

    // Gray
    public static let gray0 = UIColor(resource: .gray0)
    public static let gray50 = UIColor(resource: .gray50)
    public static let gray100 = UIColor(resource: .gray100)
    public static let gray200 = UIColor(resource: .gray200)
    public static let gray300 = UIColor(resource: .gray300)
    public static let gray400 = UIColor(resource: .gray400)
    public static let gray500 = UIColor(resource: .gray500)
    public static let gray600 = UIColor(resource: .gray600)
    public static let gray700 = UIColor(resource: .gray700)
    public static let gray800 = UIColor(resource: .gray800)
    public static let gray900 = UIColor(resource: .gray900)

    // Red
    public static let red50 = UIColor(resource: .red50)
    public static let red100 = UIColor(resource: .red100)
    public static let red200 = UIColor(resource: .red200)
    public static let red300 = UIColor(resource: .red300)
    public static let red400 = UIColor(resource: .red400)
    public static let red500 = UIColor(resource: .red500)
    public static let red600 = UIColor(resource: .red600)
    public static let red700 = UIColor(resource: .red700)
    public static let red800 = UIColor(resource: .red800)
    public static let red900 = UIColor(resource: .red900)

    // Teal
    public static let teal50 = UIColor(resource: .teal50)
    public static let teal100 = UIColor(resource: .teal100)
    public static let teal200 = UIColor(resource: .teal200)
    public static let teal300 = UIColor(resource: .teal300)
    public static let teal400 = UIColor(resource: .teal400)
    public static let teal500 = UIColor(resource: .teal500)
    public static let teal600 = UIColor(resource: .teal600)
    public static let teal700 = UIColor(resource: .teal700)
    public static let teal800 = UIColor(resource: .teal800)
    public static let teal900 = UIColor(resource: .teal900)

    // Violet
    public static let violet50 = UIColor(resource: .violet50)
    public static let violet100 = UIColor(resource: .violet100)
    public static let violet200 = UIColor(resource: .violet200)
    public static let violet300 = UIColor(resource: .violet300)
    public static let violet400 = UIColor(resource: .violet400)
    public static let violet500 = UIColor(resource: .violet500)
    public static let violet600 = UIColor(resource: .violet600)
    public static let violet700 = UIColor(resource: .violet700)
    public static let violet800 = UIColor(resource: .violet800)
    public static let violet900 = UIColor(resource: .violet900)

    // Purple
    public static let purple50 = UIColor(resource: .purple50)
    public static let purple100 = UIColor(resource: .purple100)
    public static let purple200 = UIColor(resource: .purple200)
    public static let purple300 = UIColor(resource: .purple300)
    public static let purple400 = UIColor(resource: .purple400)
    public static let purple500 = UIColor(resource: .purple500)
    public static let purple600 = UIColor(resource: .purple600)
    public static let purple700 = UIColor(resource: .purple700)
    public static let purple800 = UIColor(resource: .purple800)
    public static let purple900 = UIColor(resource: .purple900)

    // Yellow
    public static let yellow50 = UIColor(resource: .yellow50)
    public static let yellow100 = UIColor(resource: .yellow100)
    public static let yellow200 = UIColor(resource: .yellow200)
    public static let yellow300 = UIColor(resource: .yellow300)
    public static let yellow400 = UIColor(resource: .yellow400)
    public static let yellow500 = UIColor(resource: .yellow500)
    public static let yellow600 = UIColor(resource: .yellow600)
    public static let yellow700 = UIColor(resource: .yellow700)
    public static let yellow800 = UIColor(resource: .yellow800)
    public static let yellow900 = UIColor(resource: .yellow900)

    // Orange
    public static let orange50 = UIColor(resource: .orange50)
    public static let orange100 = UIColor(resource: .orange100)
    public static let orange200 = UIColor(resource: .orange200)
    public static let orange300 = UIColor(resource: .orange300)
    public static let orange400 = UIColor(resource: .orange400)
    public static let orange500 = UIColor(resource: .orange500)
    public static let orange600 = UIColor(resource: .orange600)
    public static let orange700 = UIColor(resource: .orange700)
    public static let orange800 = UIColor(resource: .orange800)
    public static let orange900 = UIColor(resource: .orange900)

    // Common
    public static let common0 = UIColor.gray0
    public static let common100 = UIColor(resource: .common100)

    // Opacity
    public static let opacity4 = UIColor(resource: .opacity4)
    public static let opacity8 = UIColor(resource: .opacity8)
    public static let opacity12 = UIColor(resource: .opacity12)
    public static let opacity16 = UIColor(resource: .opacity16)
    public static let opacity24 = UIColor(resource: .opacity24)
    public static let opacity28 = UIColor(resource: .opacity28)
    public static let opacity36 = UIColor(resource: .opacity36)
    public static let opacity44 = UIColor(resource: .opacity44)
    public static let opacity52 = UIColor(resource: .opacity52)
    public static let opacity60 = UIColor(resource: .opacity60)
    public static let opacity76 = UIColor(resource: .opacity76)
    public static let opacity88 = UIColor(resource: .opacity88)
    public static let opacity96 = UIColor(resource: .opacity96)

    // Opacity White
    public static let opacityWhite76 = UIColor(resource: .opacityWhite76)

    // MARK: - Semantic Colors

    // Saion
    public static let saion = UIColor(resource: .saion)
    public static let saionBg = UIColor(resource: .saionBg)
    
    // Primary
    public static let primaryDefault = UIColor(resource: .gray900)
    public static let primaryStrong = UIColor(resource: .common100)
    public static let primarySubtle = UIColor(resource: .gray600)
    
    // Label
    public static let labelDefault = UIColor(resource: .gray900)
    public static let labelStrong = UIColor(resource: .gray800)
    public static let labelSubtle = UIColor(resource: .gray600)
    public static let labelDisabled = UIColor(resource: .gray300)
    public static let labelMuted = UIColor(resource: .gray500)
    public static let labelInverse = UIColor(resource: .common0)
    
    // Background
    public static let backgroundDefault = UIColor(resource: .common0)
    public static let backgroundSubtle = UIColor(resource: .gray50)
    public static let backgroundMuted = UIColor(resource: .gray100)
    
    // Line
    public static let lineDefault = UIColor(resource: .gray200)
    public static let lineStrong = UIColor(resource: .gray300)
    public static let lineSubtle = UIColor(resource: .gray100)
    
    // Status
    public static let success = UIColor(resource: .success)
    public static let successBg = UIColor(resource: .successBg)
    public static let error = UIColor(resource: .error)
    public static let errorBg = UIColor(resource: .errorBg)

    public static let statusPositiveDefault = UIColor.success
    public static let statusPositiveSubtle = UIColor.successBg
    public static let statusCautionaryDefault = UIColor(resource: .orange500)
    public static let statusCautionarySubtle = UIColor(resource: .orange50)
    public static let statusNegativeDefault = UIColor.error
    public static let statusNegativeSubtle = UIColor.errorBg
    
    // Fill
    public static let fillDefault = UIColor(resource: .gray100)
    public static let fillSubtle = UIColor(resource: .gray50)
    public static let fillDisabled = UIColor(resource: .gray200)
    
    // Overlay
    public static let overlayDimmer = UIColor(resource: .opacity28)
    public static let overlayPressed = UIColor(resource: .opacity12)
    public static let overlayDisabled = UIColor(resource: .opacityWhite76)
    public static let overlayPressedSubtle = UIColor(resource: .opacity4)
}

// MARK: Color

// Primitive 컬러들도 외부 모듈에서 직접 접근할 수 있도록 public static 프로퍼티로 제공합니다.
extension Color {
    // MARK: - Primitive Colors

    // Green
    public static let green50 = Color(.green50)
    public static let green100 = Color(.green100)
    public static let green200 = Color(.green200)
    public static let green300 = Color(.green300)
    public static let green400 = Color(.green400)
    public static let green500 = Color(.green500)
    public static let green600 = Color(.green600)
    public static let green700 = Color(.green700)
    public static let green800 = Color(.green800)
    public static let green900 = Color(.green900)

    // Blue
    public static let blue50 = Color(.blue50)
    public static let blue100 = Color(.blue100)
    public static let blue200 = Color(.blue200)
    public static let blue300 = Color(.blue300)
    public static let blue400 = Color(.blue400)
    public static let blue500 = Color(.blue500)
    public static let blue600 = Color(.blue600)
    public static let blue700 = Color(.blue700)
    public static let blue800 = Color(.blue800)
    public static let blue900 = Color(.blue900)

    // Gray
    public static let gray0 = Color(.gray0)
    public static let gray50 = Color(.gray50)
    public static let gray100 = Color(.gray100)
    public static let gray200 = Color(.gray200)
    public static let gray300 = Color(.gray300)
    public static let gray400 = Color(.gray400)
    public static let gray500 = Color(.gray500)
    public static let gray600 = Color(.gray600)
    public static let gray700 = Color(.gray700)
    public static let gray800 = Color(.gray800)
    public static let gray900 = Color(.gray900)

    // Red
    public static let red50 = Color(.red50)
    public static let red100 = Color(.red100)
    public static let red200 = Color(.red200)
    public static let red300 = Color(.red300)
    public static let red400 = Color(.red400)
    public static let red500 = Color(.red500)
    public static let red600 = Color(.red600)
    public static let red700 = Color(.red700)
    public static let red800 = Color(.red800)
    public static let red900 = Color(.red900)

    // Teal
    public static let teal50 = Color(.teal50)
    public static let teal100 = Color(.teal100)
    public static let teal200 = Color(.teal200)
    public static let teal300 = Color(.teal300)
    public static let teal400 = Color(.teal400)
    public static let teal500 = Color(.teal500)
    public static let teal600 = Color(.teal600)
    public static let teal700 = Color(.teal700)
    public static let teal800 = Color(.teal800)
    public static let teal900 = Color(.teal900)

    // Violet
    public static let violet50 = Color(.violet50)
    public static let violet100 = Color(.violet100)
    public static let violet200 = Color(.violet200)
    public static let violet300 = Color(.violet300)
    public static let violet400 = Color(.violet400)
    public static let violet500 = Color(.violet500)
    public static let violet600 = Color(.violet600)
    public static let violet700 = Color(.violet700)
    public static let violet800 = Color(.violet800)
    public static let violet900 = Color(.violet900)

    // Purple
    public static let purple50 = Color(.purple50)
    public static let purple100 = Color(.purple100)
    public static let purple200 = Color(.purple200)
    public static let purple300 = Color(.purple300)
    public static let purple400 = Color(.purple400)
    public static let purple500 = Color(.purple500)
    public static let purple600 = Color(.purple600)
    public static let purple700 = Color(.purple700)
    public static let purple800 = Color(.purple800)
    public static let purple900 = Color(.purple900)

    // Yellow
    public static let yellow50 = Color(.yellow50)
    public static let yellow100 = Color(.yellow100)
    public static let yellow200 = Color(.yellow200)
    public static let yellow300 = Color(.yellow300)
    public static let yellow400 = Color(.yellow400)
    public static let yellow500 = Color(.yellow500)
    public static let yellow600 = Color(.yellow600)
    public static let yellow700 = Color(.yellow700)
    public static let yellow800 = Color(.yellow800)
    public static let yellow900 = Color(.yellow900)

    // Orange
    public static let orange50 = Color(.orange50)
    public static let orange100 = Color(.orange100)
    public static let orange200 = Color(.orange200)
    public static let orange300 = Color(.orange300)
    public static let orange400 = Color(.orange400)
    public static let orange500 = Color(.orange500)
    public static let orange600 = Color(.orange600)
    public static let orange700 = Color(.orange700)
    public static let orange800 = Color(.orange800)
    public static let orange900 = Color(.orange900)

    // Common
    public static let common0 = Color.gray0
    public static let common100 = Color(.common100)

    // Opacity
    public static let opacity4 = Color(.opacity4)
    public static let opacity8 = Color(.opacity8)
    public static let opacity12 = Color(.opacity12)
    public static let opacity16 = Color(.opacity16)
    public static let opacity24 = Color(.opacity24)
    public static let opacity28 = Color(.opacity28)
    public static let opacity36 = Color(.opacity36)
    public static let opacity44 = Color(.opacity44)
    public static let opacity52 = Color(.opacity52)
    public static let opacity60 = Color(.opacity60)
    public static let opacity76 = Color(.opacity76)
    public static let opacity88 = Color(.opacity88)
    public static let opacity96 = Color(.opacity96)

    // Opacity White
    public static let opacityWhite76 = Color(.opacityWhite76)

    // MARK: - Semantic Colors

    // Saion
    public static let saion = Color(.saion)
    public static let saionBg = Color(.saionBg)
    
    // Primary
    public static let primaryDefault = Color(.gray900)
    public static let primaryStrong = Color(.common100)
    public static let primarySubtle = Color(.gray600)
    
    // Label
    public static let labelDefault = Color(.gray900)
    public static let labelStrong = Color(.gray800)
    public static let labelSubtle = Color(.gray600)
    public static let labelDisabled = Color(.gray300)
    public static let labelMuted = Color(.gray500)
    public static let labelInverse = Color(.common0)
    
    // Background
    public static let backgroundDefault = Color(.common0)
    public static let backgroundSubtle = Color(.gray50)
    public static let backgroundMuted = Color(.gray100)
    
    // Line
    public static let lineDefault = Color(.gray200)
    public static let lineStrong = Color(.gray300)
    public static let lineSubtle = Color(.gray100)
    
    // Status
    public static let success = Color(.success)
    public static let successBg = Color(.successBg)
    public static let error = Color(.error)
    public static let errorBg = Color(.errorBg)

    public static let statusPositiveDefault = Color.success
    public static let statusPositiveSubtle = Color.successBg
    public static let statusCautionaryDefault = Color(.orange500)
    public static let statusCautionarySubtle = Color(.orange50)
    public static let statusNegativeDefault = Color.error
    public static let statusNegativeSubtle = Color.errorBg
    
    // Fill
    public static let fillDefault = Color(.gray100)
    public static let fillSubtle = Color(.gray50)
    public static let fillDisabled = Color(.gray200)
    
    // Overlay
    public static let overlayDimmer = Color(.opacity28)
    public static let overlayPressed = Color(.opacity12)
    public static let overlayDisabled = Color(.opacityWhite76)
    public static let overlayPressedSubtle = Color(.opacity4)
}
