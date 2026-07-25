//
//  InboxVM.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

import Combine
import Foundation

import CasePaths

final class InboxVM {
    
    // MARK: Types
    
    enum Action {
        /// 화면 진입 후 최초 알림 목록 조회 요청
        case viewDidLoad
        /// 노출된 셀 인덱스를 기준으로 다음 페이지 조회 여부 확인
        case cellWillDisplay(index: Int)
    }
    
    struct State {
        /// 페이지네이션 정보와 원본 알림 목록
        fileprivate var inboxItemsPage: Pagenation<InboxItem>?
        /// 알림 컬렉션뷰에 표시할 아이템 목록
        var inboxItems: [InboxCellItem] {
            let relativeDateFormatter = RelativeDateTimeFormatter()
            relativeDateFormatter.locale = Locale(identifier: "ko_KR")
            relativeDateFormatter.unitsStyle = .full
            relativeDateFormatter.dateTimeStyle = .named
            
            return inboxItemsPage?.elemets.map {
                InboxCellItem(
                    id: $0.id,
                    title: $0.title,
                    date: relativeDateFormatter.localizedString(
                        for: $0.occurredAt,
                        relativeTo: .now
                    ),
                    caption: $0.body
                )
            } ?? []
        }
        /// 다음 페이지 조회 진행 여부
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Effect {
        /// 상태 전이 중 발생한 에러
        case presentError(LocalizedError)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
    let effect = PassthroughSubject<Effect, Never>()
    
    private let inboxRepo: InboxRepo
    
    // MARK: Initializer
    
    init(inboxRepo: InboxRepo) {
        self.inboxRepo = inboxRepo
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
            // 화면 진입 시 알림 첫 페이지를 조회한다.
            state.inboxItemsPage = try await inboxRepo.fetchInbox(
                cursor: nil
            )
            
        case .cellWillDisplay(let index):
            // 다음 페이지가 있고 마지막 5개 셀에 진입했을 때만 선조회한다.
            guard let currentPage = state.inboxItemsPage,
                  currentPage.hasNext,
                  index >= currentPage.elemets.count - 5,
                  !state.isLoading
            else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            let nextPage = try await inboxRepo.fetchInbox(
                cursor: currentPage.nextCursor
            )
            
            // 기존 목록 뒤에 새 알림을 붙이고 다음 조회를 위한 커서 정보를 갱신한다.
            state.inboxItemsPage?.elemets.append(contentsOf: nextPage.elemets)
            state.inboxItemsPage?.nextCursor = nextPage.nextCursor
            state.inboxItemsPage?.hasNext = nextPage.hasNext
        }
    }
}
