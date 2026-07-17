//
//  ToastHostVC.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import SnapKit

final class ToastHostVC: UIViewController {
    
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
        let presentPublisher = ToastCenter.shared.presentSubject
            .receive(on: DispatchQueue.main)
            .share()
        
        presentPublisher
            .sink { [weak self] message in
                guard let self else { return }
                toastView.messageLabel.text = message
                
                guard toastView.isHidden else { return }
                toastView.present()
            }
            .store(in: &cancellables)
        
        presentPublisher
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in self?.toastView.dismiss() }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview { ToastHostVC() }
