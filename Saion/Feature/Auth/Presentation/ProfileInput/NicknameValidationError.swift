//
//  NicknameValidationError.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

import Foundation

/// 닉네임 유효성 에러
enum NicknameValidationError: LocalizedError, Equatable {
    case tooLong
    case emptyOrWhitespace
    case containsSpecialChar
    
    var errorDescription: String? {
        return switch self {
        case .tooLong:              "10자 이내로 입력해주세요."
        case .emptyOrWhitespace:    "닉네임을 입력해주세요."
        case .containsSpecialChar:  "한글, 영문, 숫자만 사용할 수 있어요."
        }
    }
}
