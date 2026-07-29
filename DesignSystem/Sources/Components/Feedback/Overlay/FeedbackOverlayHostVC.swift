//
//  FeedbackOverlayHostVC.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

final class FeedbackOverlayHostVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let toastView = ToastView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(108)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        setupToastBindings()
        setupAlertBindings()
    }
    
    private func setupToastBindings() {
        ToastCenter.shared.presentPublisher
            .sink { [weak self] message in
                guard let self else { return }
                toastView.messageLabel.text = message
                guard toastView.isHidden else { return }
                toastView.present()
            }
            .store(in: &cancellables)
        
        ToastCenter.shared.presentPublisher
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in self?.toastView.dismiss() }
            .store(in: &cancellables)
    }
    
    private func setupAlertBindings() {
        AlertCenter.shared.actionPublisher
            .sink { [weak self] in self?.process(alertAction: $0) }
            .store(in: &cancellables)
    }
    
    // MARK: Process
    
    private func process(alertAction: AlertCenter.Action) {
        guard presentedViewController == nil else { return }
        
        switch alertAction {
        case .presentError(let error):
            let alert = NoticeAlertVC()
            alert.titleLabel.text = "문제가 발생했어요"
            alert.descriptionLabel.text = error.errorDescription
            
            alert.acceptButton.tapPublisher
                .sink { [weak alert] in alert?.dismiss(animated: true) }
                .store(in: &alert.cancellables)
            
            present(alert, animated: true)
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview { FeedbackOverlayHostVC() }
