//
//  InboxDI.swift
//  Saion
//
//  Created by 신정욱 on 7/24/26.
//

final class InboxDI {
    
    // MARK: Singleton
    
    static let shared = InboxDI()
    private init() {}
    
    // MARK: Methods
    
    func makeInboxVM() -> InboxVM {
        InboxVM(inboxRepo: DefaultInboxRepo())
    }
}
