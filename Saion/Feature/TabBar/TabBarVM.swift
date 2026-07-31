//
//  TabBarVM.swift
//  Saion
//
//  Created by 신정욱 on 7/28/26.
//

import Combine
import Foundation

import CasePaths

import DesignSystem

final class TabBarVM {
    
    // MARK: Types
    
    enum Action {
        /// 최초 진입에 필요한 서클 정보 조회
        case viewDidLoad
        /// 사용자가 선택한 탭 인덱스 전달
        case indexChanged(Int)
    }
    
    struct State {
        /// 현재 사용 중인 서클 ID. 가입한 서클이 없으면 `nil`
        var currentCircleID: String?
    }
    
    @CasePathable
    enum Effect {
        /// 접근 가능한 탭으로 화면 전환 요청
        case selectTabIndex(Int)
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    /// 가입한 서클 정보를 조회하는 저장소
    private let circleRepo: CircleRepo
    
    // MARK: Initializer
    
    init(
        state: State = State(),
        circleRepo: CircleRepo
    ) {
        self.state = state
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
        case .viewDidLoad:
            do {
                // 첫 번째 가입 서클을 현재 서클로 설정해 탭 화면 구성을 시작
                state.currentCircleID = try await circleRepo.fetchJoinedCircles().first?.circleID
            } catch {
                // 초기 서클 정보가 유효하지 않으면 세션을 종료하고 인증 흐름으로 복귀
                AlertCenter.shared.send(.presentError(SaionError(
                    userMessage: "가입한 서클 정보를 불러오는 중 문제가 발생했어요.\n잠시 후 다시 로그인해 주세요.",
                    errorCode: "TBVM-VDL-0"
                )))
                AuthManager.shared.send(.userDidLogout)
            }
            
        case .indexChanged(let index):
            // 가입한 서클이 없으면 일정 탭 진입을 차단
            if index == 1, state.currentCircleID == nil {
                ToastCenter.shared.present(message: "서클에 가입하면 일정을 확인할 수 있어요.")
                return
            }
            
            // 접근 검증을 통과한 탭만 화면에 선택 요청
            effect.send(.selectTabIndex(index))
        }
    }
}
