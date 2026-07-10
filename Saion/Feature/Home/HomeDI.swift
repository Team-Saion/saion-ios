//
//  HomeDI.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

final class HomeDI {
    
    // MARK: Singleton
    
    static let shared = HomeDI()
    private init() {}
    
    // MARK: Methods
    
    func makeHomeVM() -> HomeVM {
        HomeVM(circleRepo: DefaultCircleRepo())
    }
    
    func makeCircleInitializationVM() -> CircleInitializationVM {
        CircleInitializationVM(circleRepo: DefaultCircleRepo())
    }
}
