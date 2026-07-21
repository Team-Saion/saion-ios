//
//  ScheduleDI.swift
//  Saion
//
//  Created by 신정욱 on 7/17/26.
//

final class ScheduleDI {
    
    // MARK: Singleton
    
    static let shared = ScheduleDI()
    private init() {}
    
    // MARK: Methods
    
    func makeCreateScheduleVM() -> CreateScheduleVM {
        CreateScheduleVM(scheduleRepo: DefaultScheduleRepo())
    }
    
    func makeScheduleListVM() -> ScheduleListVM {
        ScheduleListVM(scheduleRepo: DefaultScheduleRepo())
    }

    func makeScheduleDetailVM(scheduleID: String) -> ScheduleDetailVM {
        ScheduleDetailVM(
            scheduleID: scheduleID,
            scheduleRepo: DefaultScheduleRepo()
        )
    }
}
