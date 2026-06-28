//
//  AuthDI.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

final class AuthDI {
    
    // MARK: Singleton
    
    static let shared = AuthDI()
    private init() {}
    
    // MARK: Methods
    
    func makeLoginVM() -> LoginVM {
        LoginVM(
            kakaoAuthRepo: DefaultKakaoAuthRepo(),
            loginRepo: DefaultLoginRepo()
        )
    }
}
