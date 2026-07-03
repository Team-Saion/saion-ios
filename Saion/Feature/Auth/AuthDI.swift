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
            loginRepo: DefaultLoginRepo(),
            onboardingRepo: DefaultOnboardingRepo()
        )
    }
    
    func makeTermsSheetVM() -> TermsSheetVM {
        TermsSheetVM(onboardingRepo: DefaultOnboardingRepo())
    }
    
    func makeProfileInputVM(onboardingInfo: OnboardingInfo) -> ProfileInputVM {
        ProfileInputVM(
            onboardingInfo: onboardingInfo,
            onboardingRepo: DefaultOnboardingRepo()
        )
    }
}
