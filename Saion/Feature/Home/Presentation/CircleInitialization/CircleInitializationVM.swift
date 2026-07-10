//
//  CircleInitializationVM.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

import Combine
import Foundation

import CasePaths

final class CircleInitializationVM {
    
    // MARK: Types
    
    enum Action {
        /// 텍스트 입력됨
        case textChanged(String?)
        /// 시작하기 버튼 탭
        case submitTapped
    }
    
    struct State {
        /// 서클 이름 텍스트
        var circleNameText: String?
        
        /// 유효성 에러 (서클 이름 데이터만 보고 판단)
        fileprivate var validationError: CircleValidationError? {
            guard let circleNameText else { return nil }
            
            // 1순위: 20자 초과 → "20자 이내로 입력해주세요."
            if circleNameText.count > 20 { return .tooLong }
            
            // 2순위: 공백만 있음 → "써클 이름을 입력해주세요."
            let trimmed = circleNameText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty { return .emptyOrWhitespace }
            
            return nil
        }
        
        /// 하단 캡션 텍스트
        var captionText: String {
            // 에러가 있다면 에러 메시지 우선 노출
            validationError?.errorDescription ?? "\(circleNameText?.count ?? 0)/20"
        }
        
        /// 유효성 에러 여부
        var hasValidationError: Bool { validationError != nil }
        
        /// 서클 이름 유효 여부 (버튼 비활성화 목적)
        var isValidCircleName: Bool {
            guard let circleNameText else { return false }
            // 2자 미만일 때는 유효하지 않음
            return circleNameText.count >= 2 && !hasValidationError
        }
        
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
        /// 서클 생성 완료 이벤트
        case circleCreated
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    private let circleRepo: CircleRepo
    
    // MARK: Initializer
    
    init(circleRepo: CircleRepo) {
        self.circleRepo = circleRepo
    }
    
    // MARK: Send
    
    func send(_ action: Action) {
        Task { @MainActor in
            do {
                try await process(action: action)
            } catch let error as LocalizedError {
                effect.send(.presentError(error))
            }
        }
    }
    
    // MARK: Process
    
    private func process(action: Action) async throws {
        switch action {
        case .textChanged(let text):
            state.circleNameText = text?.isEmpty == false ? text : nil
            
        case .submitTapped:
            guard !state.isLoading, state.circleNameText != nil else { return }
            
            state.isLoading = true
            defer { state.isLoading = false }
            
            _ = try await circleRepo.createCircle(name: state.circleNameText)
            effect.send(.circleCreated)
        }
    }
}
