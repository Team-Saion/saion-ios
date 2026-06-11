//
//  FontRegistry.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/11/26.
//

import CoreText
import Foundation

final class FontRegistry {
    
    // MARK: Properties
    
    /// 폰트 파일 등록 여부
    nonisolated(unsafe) private static var isRegistered = false
    private static let lock = NSLock()
    
    // MARK: Method
    
    /// Pretendard 폰트 파일들을 CoreText에 등록
    static func registerFonts() {
        // 이중 검사 락(Double-Checked Locking
        guard !isRegistered else { return }
        lock.lock()
        defer { lock.unlock() }
        guard !isRegistered else { return }
        
        Typography.FontWeight.allCases.forEach {
            registerFont(name: $0.rawValue)
        }
        isRegistered = true
    }
    
    // MARK: Private Helper
    
    private static func registerFont(name: String) {
        // Resources 폴더(또는 서브폴더) 내의 파일 URL 검색 (.otf 확장자 명시)
        guard let url = Bundle.module.url(forResource: name, withExtension: "otf") ??
                Bundle.module.url(forResource: name, withExtension: "otf", subdirectory: "Fonts"),
              let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider) else {
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            // 이미 등록되어 있거나 에러가 발생한 경우 출력
            print("Pretendard register status for \(name): \(error.debugDescription)")
        }
    }
}
