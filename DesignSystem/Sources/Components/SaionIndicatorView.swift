//
//  SaionIndicatorView.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/14/26.
//

import UIKit

import SnapKit

public final class SaionIndicatorView: UIView {
    
    // MARK: Components
    
    private let indicatorImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .indicatorRing)
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        // 애니메이션 추가 및 시작
        let animeKey = "rotation"
        
        guard indicatorImageView.layer.animation(forKey: animeKey) == nil else { return }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.isRemovedOnCompletion = false
        
        indicatorImageView.layer.add(animation, forKey: animeKey)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(indicatorImageView)
        indicatorImageView.snp.makeConstraints {
            $0.center.equalTo(safeAreaLayoutGuide)
            $0.size.equalTo(64)
        }
    }
    
    // MARK: Reactive Interface
    
    public func setAnimating(_ isAnimating: Bool) {
        isUserInteractionEnabled = isAnimating
        if isAnimating { isHidden = false }
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseInOut]
        ) { [weak self] in
            self?.alpha = isAnimating ? 1 : 0
            
        } completion: { [weak self] isFinished in
            guard !isAnimating, isFinished else { return }
            self?.isHidden = true
        }
    }
}

// MARK: - Preview

private final class SaionIndicatorPreviewVC: UIViewController {
    
    private let indicatorView = SaionIndicatorView()
    private let animationControl = UISegmentedControl(items: ["시작", "정지"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupActions()
    }
    
    private func setupDefaults() {
        view.backgroundColor = .systemBackground
        animationControl.selectedSegmentIndex = 0
        indicatorView.setAnimating(true)
    }
    
    private func setupLayout() {
        view.addSubview(indicatorView)
        view.addSubview(animationControl)
        
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        animationControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(160)
        }
    }
    
    private func setupActions() {
        animationControl.addTarget(
            self,
            action: #selector(animationStateChanged),
            for: .valueChanged
        )
    }
    
    @objc private func animationStateChanged() {
        indicatorView.setAnimating(animationControl.selectedSegmentIndex == 0)
    }
}

#Preview { SaionIndicatorPreviewVC() }
