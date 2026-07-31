//
//  HomeCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

import Combine
import UIKit

import CombineCocoa

import Navigation

final class HomeCoord: Coordinator {

    // MARK: Subjects

    private let joinedCirclesDidChangeSubject = PassthroughSubject<Void, Never>()

    var joinedCirclesDidChangePublisher: AnyPublisher<Void, Never> {
        joinedCirclesDidChangeSubject.eraseToAnyPublisher()
    }

    // MARK: Start

    func start(circleID: String?) {
        let vc: UIViewController

        if let circleID {
            let vm = HomeDI.shared.makeCircleOverviewVM(circleID: circleID)
            let overviewVC = CircleOverviewVC(vm: vm)
            vc = overviewVC

            // 일정 생성 화면으로 이동
            overviewVC.createSchedulePublisher
                .sink { [weak self] in self?.presentCreateScheduleVC(circleID: circleID) }
                .store(in: &cancellables)

            // 전체 구성원 목록 화면으로 이동
            overviewVC.showAllMembersTapPublisher
                .sink { [weak self] in self?.pushMemberListVC(circleID: circleID) }
                .store(in: &cancellables)

            // 알림 목록 화면으로 이동
            overviewVC.notificationTapPublisher
                .sink { [weak self] in self?.pushInboxVC() }
                .store(in: &cancellables)

        } else {
            let entryVC = CircleEntryVC()
            vc = entryVC

            // 서클 참여 화면으로 이동
            entryVC.joinButton.tapPublisher
                .compactMap { [weak self] in self?.presentJoinCircle() }
                .switchToLatest()
                .sink { [weak self] in self?.joinedCirclesDidChangeSubject.send() }
                .store(in: &cancellables)

            // 서클 생성 화면으로 이동
            entryVC.createButton.tapPublisher
                .compactMap { [weak self] in self?.presentCircleInitializationVC() }
                .switchToLatest()
                .sink { [weak self] in self?.joinedCirclesDidChangeSubject.send() }
                .store(in: &cancellables)
        }

        // 화면 전환
        navigation.pushViewController(vc, animated: false)
    }

    /// 서클 참여 흐름 시작
    private func presentJoinCircle() -> AnyPublisher<Void, Never> {
        let coord = JoinCircleCoord(navigation: .init())
        coord.navigation.modalPresentationStyle = .fullScreen

        // 참여 흐름 종료 시 자식 코디네이터 해제
        coord.didFinishPublisher
            .sink { [weak self, weak coord] in self?.free(child: coord) }
            .store(in: &coord.cancellables)

        store(child: coord)
        coord.start()
        navigation.present(coord.navigation, animated: true)

        return coord.circleJoinedPublisher
    }

    /// 서클 생성 화면으로 이동
    func presentCircleInitializationVC() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let vc = CircleInitializationVC()
            vc.modalPresentationStyle = .fullScreen

            // 서클 생성 완료 시, 화면 닫고 이벤트 외부로 전달
            vc.circleCreatedPublisher
                .sink { [weak vc] in
                    vc?.dismiss(animated: true)
                    promise(.success(()))
                }
                .store(in: &vc.cancellables)

            // 화면 전환
            self?.navigation.present(vc, animated: true)
        } }
        .eraseToAnyPublisher()
    }

    /// 일정 생성 화면으로 이동
    private func presentCreateScheduleVC(circleID: String) {
        let vm = ScheduleDI.shared.makeCreateScheduleVM(circleID: circleID)
        let vc = CreateScheduleVC(vm: vm)
        vc.modalPresentationStyle = .fullScreen

        // 화면 전환
        navigation.present(vc, animated: true)
    }

    /// 전체 구성원 목록 화면으로 이동
    func pushMemberListVC(circleID: String) {
        let vm = HomeDI.shared.makeMemberListVM(circleID: circleID)
        let vc = MemberListVC(vm: vm)
        vc.hidesDefaultTabBarWhenPushed = true

        // 뒤로가기 탭하면 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &vc.cancellables)

        navigation.pushViewController(vc, animated: true)
    }

    /// 알림 목록 화면으로 이동
    func pushInboxVC() {
        let vc = InboxVC()
        vc.hidesDefaultTabBarWhenPushed = true

        // 뒤로가기 탭하면 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &vc.cancellables)

        navigation.pushViewController(vc, animated: true)
    }
}
