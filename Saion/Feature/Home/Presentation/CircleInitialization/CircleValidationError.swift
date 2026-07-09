//
//  CircleValidationError.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import Foundation

/// 서클 생성 유효성 에러
enum CircleValidationError: LocalizedError, Equatable {
    case tooLong
    case emptyOrWhitespace
    
    var errorDescription: String? {
        return switch self {
        case .tooLong:              "20자 이내로 입력해주세요."
        case .emptyOrWhitespace:    "써클 이름을 입력해주세요."
        }
    }
}
