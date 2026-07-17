//
//  ToastView.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/17/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

final class ToastView: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let panGesture = UIPanGestureRecognizer()
    
    let messageLabel = {
        let style = TextStyle(
            typography: .title3,
            decoration: .init(foregroundColor: .labelInverse)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 16)
        alignment = .center
        spacing = 6
        isHidden = true
        
        addGestureRecognizer(panGesture)
        
        layer.shadowColor = Shadow.component.shadowColor
        layer.shadowOpacity = Shadow.component.shadowOpacity
        layer.shadowOffset = Shadow.component.shadowOffset
        layer.shadowRadius = Shadow.component.shadowRadius
        
        layer.cornerRadius = 24
        backgroundColor = .primarySubtle
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(messageLabel)
        self.snp.makeConstraints { $0.height.equalTo(48)}
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        panGesture.panPublisher
            .sink { [weak self] in self?.handlePanGesture($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            let translation = gesture.translation(in: self)
            let verticalLimit: CGFloat = translation.y > 0 ? 32 : 4
            let resistance: CGFloat = 72
            let dampedY = translation.y
            / (abs(translation.y) + resistance)
            * verticalLimit
            
            transform = .init(translationX: 0, y: dampedY)
            
        case .ended, .cancelled, .failed:
            let velocity = gesture.velocity(in: self)
            
            if velocity.y > 300 {
                dismiss(offset: max(transform.ty, 0))
                return
            }
            
            UIView.animate(
                withDuration: 0.32,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0,
                options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]
            ) { [weak self] in
                self?.transform = .identity
            }
            
        default:
            break
        }
    }
    
    // MARK: Public Methods
    
    func present() {
        transform = .init(translationX: 0, y: frame.height / 3)
        isUserInteractionEnabled = false
        isHidden = false
        alpha = 0
        
        UIView.animate(
            withDuration: 0.32,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]
        ) { [weak self] in
            self?.transform = .identity
            self?.alpha = 1
            
        } completion: { [weak self] _ in
            self?.isUserInteractionEnabled = true
        }
    }
    
    func dismiss(offset: CGFloat = .zero) {
        isUserInteractionEnabled = false
        
        UIView.animate(
            withDuration: 0.32,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]
        ) { [weak self] in
            guard let self else { return }
            transform = .init(translationX: 0, y: frame.height / 3 + offset)
            alpha = 0
            
        } completion: { [weak self] _ in
            self?.isHidden = true
        }
    }
}
