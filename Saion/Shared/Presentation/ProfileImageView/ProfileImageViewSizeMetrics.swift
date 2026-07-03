//
//  ProfileImageViewSizeMetrics.swift
//  Saion
//
//  Created by 신정욱 on 7/2/26.
//

import Foundation

import DesignSystem

struct ProfileImageViewSizeMetrics {
    let size: CGSize
    let typography: TextStyle.Typography
    
    static let large: Self = .init(
        size: CGSize(width: 80, height: 80),
        typography: .display2
    )
    
    static let medium: Self = .init(
        size: CGSize(width: 64, height: 64),
        typography: .heading1
    )
    
    static let small: Self = .init(
        size: CGSize(width: 40, height: 40),
        typography: .label1Strong
    )
}
