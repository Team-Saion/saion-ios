//
//  MyPageDI.swift
//  Saion
//
//  Created by 신정욱 on 7/20/26.
//

final class MyPageDI {
    
    // MARK: Singleton
    
    static let shared = MyPageDI()
    private init() {}
    
    // MARK: Methods
    
    func makeMyPageVM() -> MyPageVM {
        MyPageVM(memberRepo: DefaultMemberRepo())
    }
    
    func makeDeleteAccountReasonVM() -> DeleteAccountReasonVM {
        DeleteAccountReasonVM(memberRepo: DefaultMemberRepo())
    }
}
