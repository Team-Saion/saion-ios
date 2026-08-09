//
//  AppleSignInClient.swift
//  Saion
//
//  Created by 신정욱 on 8/9/26.
//

import AuthenticationServices

final class AppleSignInClient: NSObject {
    
    // MARK: Properties
    
    /// 인증창을 보여줄 윈도우
    private weak var window: UIWindow?
    
    /// 애플 인증 프로세스를 관리하는 컨트롤러
    private let controller = {
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        requset.requestedScopes = [.email, .fullName] // 사용자에게 제공받을 정보를 선택
        return ASAuthorizationController(authorizationRequests: [requset])
    }()
    
    /// 애플 로그인 결과를 async 호출부에 전달하기 위한 continuation
    private var continuation: CheckedContinuation<String, any Error>?
    
    // MARK: Life Cycle
    
    override init() {
        super.init()
        controller.presentationContextProvider = self // 인증창을 보여주기 위해 대리자 설정
        controller.delegate = self // 로그인 정보 관련 대리자 설정
    }
    
    // MARK: Async Interface
    
    /// 애플 로그인을 수행하고 아이디 토큰을 반환
    func signIn(presenter window: UIWindow) async throws -> String {
        // 인증창이 표시될 앵커를 설정하기 위해 전달받은 윈도우를 저장
        self.window = window
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            controller.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleSignInClient: ASAuthorizationControllerPresentationContextProviding {
    /// 인증창을 보여줄 윈도우 설정
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        guard let window else { preconditionFailure("애플 로그인 인증창을 표시할 UIWindow가 필요해요.") }
        return window
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleSignInClient: ASAuthorizationControllerDelegate {
    /// 로그인 실패 시 호출됨
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        let continuation = continuation
        self.continuation = nil
        continuation?.resume(throwing: SaionError(
            with: error,
            userMessage: "애플 인증 중 문제가 발생했어요.",
            errorCode: "AAS-PA-0"
        ))
    }
    
    /// 로그인 성공 시 호출됨
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTokenData = credential.identityToken
        else {
            let continuation = continuation
            self.continuation = nil
            continuation?.resume(throwing: SaionError(
                userMessage: "애플 인증 정보를 확인할 수 없어요.",
                errorCode: "AAS-PA-1"
            ))
            return
        }
        
        let idToken = String(decoding: idTokenData, as: UTF8.self)
        let continuation = continuation
        self.continuation = nil
        continuation?.resume(returning: idToken)
    }
}
