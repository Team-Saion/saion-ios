//
//  AlertDemoVC.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/30/26.
//

import UIKit

import SnapKit

public final class AlertDemoVC: UIViewController {
    
    // MARK: Components
    
    private let mainVStack = UIStackView(
        .vertical,
        alignment: .center,
        spacing: 16,
        inset: .init(horizontal: 20)
    )
    
    private let titleLabel = {
        let style = TextStyle(
            typography: .heading2,
            decoration: .init(foregroundColor: .labelDefault),
            paragraph: .init(alignment: .center)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.numberOfLines = 0
        label.text = "AlertVC Demo"
        return label
    }()
    
    private let descriptionLabel = {
        let style = TextStyle(
            typography: .body2,
            decoration: .init(foregroundColor: .labelSubtle),
            paragraph: .init(alignment: .center)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.numberOfLines = 0
        label.text = "버튼을 누르면 기존 AlertVC를 그대로 present해요."
        return label
    }()
    
    private let presentButton = {
        let button = SaionButton(
            with: .init(size: .xlarge, variant: .primary)
        )
        button.title = "AlertVC Present"
        return button
    }()
    
    // MARK: Life Cycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupActions()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .backgroundMuted
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(descriptionLabel)
        mainVStack.addArrangedSubview(presentButton)
        
        mainVStack.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        presentButton.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    private func setupActions() {
        presentButton.addTarget(
            self,
            action: #selector(presentAlertVC),
            for: .touchUpInside
        )
    }
    
    @objc private func presentAlertVC() {
        let alertVC = NoticeAlertVC()
        alertVC.titleLabel.text = "AlertVC"
        alertVC.descriptionLabel.text = "기존 AlertVC를 수정하지 않고 데모 화면에서만 present하고 있어요."
        present(alertVC, animated: true)
    }
}

// MARK: - Preview

#Preview { AlertDemoVC() }
