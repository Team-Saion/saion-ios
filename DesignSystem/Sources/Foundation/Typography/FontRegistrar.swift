//
//  FontRegistrar.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/11/26.
//

import CoreText
import Foundation

final class FontRegistrar {
    
    // MARK: Properties
    
    /// 폰트 파일 등록 여부
    nonisolated(unsafe) private static var isRegistered = false
    private static let lock = NSLock()
    
    // MARK: Method
    
    /// Pretendard 폰트 파일들을 CoreText에 등록
    static func registerFonts() {
        // 이중 검사 락(Double-Checked Locking)
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
        // Swift Package 리소스 번들 안의 Fonts 폴더에서 otf 파일 URL 조회
        guard let url = Bundle.module.url(
            forResource: name,
            withExtension: "otf"
        ) else {
            print("[FontRegistrar] \(name) 폰트 파일을 찾을 수 없음")
            return
        }
        
        // CoreText 등록 실패 시 상세 원인을 받기 위한 에러 포인터
        var error: Unmanaged<CFError>?
        
        // 폰트 파일 URL을 CoreText에 등록해 현재 앱 프로세스에서 사용할 수 있게 함
        let isFontRegistered = CTFontManagerRegisterFontsForURL(
            url as CFURL,
            .process,
            &error
        )
        
        // 등록 성공이거나 전달된 에러가 없으면 별도 처리 없이 종료
        guard !isFontRegistered, let error else { return }
        print("[FontRegistrar] \(name) 폰트 등록 실패: \(error.takeRetainedValue())")
    }
}
