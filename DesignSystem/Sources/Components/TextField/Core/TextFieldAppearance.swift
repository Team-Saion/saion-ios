//
//  TextFieldAppearance.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/9/26.
//

protocol TextFieldAppearance: Equatable {
    static func appearance(for state: TextFieldState) -> Self
}
