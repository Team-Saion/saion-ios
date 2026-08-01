//
//  PushNotificationSettingsVC.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class PushNotificationSettingsVC: BackButtonVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    private let vm = MyPageDI.shared.makePushNotificationSettingsVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, spacing: 28, inset: .init(edges: 20))
    
    private let d7Row = ToggleRow(title: "D-7 알림")
    private let d1Row = ToggleRow(title: "D-1 알림")
    private let dDayRow = ToggleRow(title: "D-Day 알림")
    private let familyScheduleCheckRow = ToggleRow(title: "가족 반응 알림")
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .backgroundDefault
        defaultNavBar.titleLabel.text = "알림 설정"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(d7Row)
        mainVStack.addArrangedSubview(d1Row)
        mainVStack.addArrangedSubview(dDayRow)
        mainVStack.addArrangedSubview(familyScheduleCheckRow)
        
        mainVStack.snp.makeConstraints { $0.top.horizontalEdges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        vm.send(.viewDidLoad)
        
        // D-7 알림 설정 변경 이벤트 전달
        d7Row.toggle.isOnPublisher
            .sink { [weak self] in self?.vm.send(.d7Changed($0)) }
            .store(in: &cancellables)
        
        // D-1 알림 설정 변경 이벤트 전달
        d1Row.toggle.isOnPublisher
            .sink { [weak self] in self?.vm.send(.d1Changed($0)) }
            .store(in: &cancellables)
        
        // D-Day 알림 설정 변경 이벤트 전달
        dDayRow.toggle.isOnPublisher
            .sink { [weak self] in self?.vm.send(.dDayChanged($0)) }
            .store(in: &cancellables)
        
        // 가족 반응 알림 설정 변경 이벤트 전달
        familyScheduleCheckRow.toggle.isOnPublisher
            .sink { [weak self] in self?.vm.send(.familyScheduleCheckChanged($0)) }
            .store(in: &cancellables)
        
        // 알림 설정 상태를 각 토글에 반영
        vm.$state.compactMap(\.notificationSettings).removeDuplicates()
            .sink { [weak self] settings in
                self?.d7Row.toggle.isOn = settings.d7Enabled
                self?.d1Row.toggle.isOn = settings.d1Enabled
                self?.dDayRow.toggle.isOn = settings.dDayEnabled
                self?.familyScheduleCheckRow.toggle.isOn = settings.familyScheduleCheckEnabled
            }
            .store(in: &cancellables)
        
        // 로딩 상태에 따라 로딩 인디케이터 노출 여부 갱신
        vm.$state.map(\.isLoading).removeDuplicates()
            .sink { [weak self] in self?.setLoadingIndicatorVisible($0) }
            .store(in: &cancellables)
        
        // 상태 전이 중 발생한 에러를 알림으로 표시
        vm.effect.compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - ToggleRow

private final class ToggleRow: UIStackView {
    
    // MARK: Properties
    
    private let title: String
    
    // MARK: Components
    
    private lazy var titleLabel = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = UILabel()
        label.attributedText = style.toNSAttrStr(title)
        return label
    }()
    
    let toggle = UISwitch()
    
    // MARK: Life Cycle
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        alignment = .center
        spacing = 8
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(toggle)
    }
}

// MARK: - Preview

#Preview { PushNotificationSettingsVC() }
