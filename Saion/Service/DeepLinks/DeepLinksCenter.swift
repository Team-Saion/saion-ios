//
//  DeepLinksCenter.swift
//  Saion
//
//  Created by 신정욱 on 7/26/26.
//

import Combine
import Foundation

import CasePaths

final class DeepLinksCenter {
    
    @CasePathable
    enum Event {
        case routeJoinCircle(invitationCode: String)
    }
    
    // MARK: Singleton
    
    static let shared = DeepLinksCenter()
    private init() {}
    
    // MARK: Properties
    
    @Published var pending: Event?
}
