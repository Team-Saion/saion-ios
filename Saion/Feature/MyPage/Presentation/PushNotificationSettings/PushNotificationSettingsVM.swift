//
//  PushNotificationSettingsVM.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Combine
import UIKit

import CasePaths

final class PushNotificationSettingsVM {
    
    // MARK: Types
    
    enum Action {
        case viewDidLoad
        case d7Changed(Bool)
        case d1Changed(Bool)
        case dDayChanged(Bool)
        case familyScheduleCheckChanged(Bool)
    }
    
    struct State {
        var notificationSettings: PushNotificationSettings?
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
    
    private let settingsRepo: SettingsRepo
    
    // MARK: Initializer
    
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
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
            guard !state.isLoading else { return }
            defer { state.isLoading = false }
            state.isLoading = true
            
            state.notificationSettings = try await settingsRepo.fetchPushNotificationSettings()
            
        case .d7Changed(let bool):
            state.notificationSettings?.d7Enabled = bool
            try await updateSettings()
            
        case .d1Changed(let bool):
            state.notificationSettings?.d1Enabled = bool
            try await updateSettings()
            
        case .dDayChanged(let bool):
            state.notificationSettings?.dDayEnabled = bool
            try await updateSettings()
            
        case .familyScheduleCheckChanged(let bool):
            state.notificationSettings?.familyScheduleCheckEnabled = bool
            try await updateSettings()
        }
    }
    
    // MARK: Private Helper
    
    private func updateSettings() async throws {
        guard !state.isLoading else { return }
        defer { state.isLoading = false }
        state.isLoading = true
        
        guard let settings = state.notificationSettings else { return }
        
        state.notificationSettings =
        try await settingsRepo.updatePushNotificationSettings(settings)
    }
}
