//
//  BottomSheetDemoVC.swift
//  DesignSystem
//
//  Created by Codex on 6/30/26.
//

import UIKit

import SnapKit

final class BottomSheetDemoVC: UIViewController {
    
    // MARK: Properties
    
    private var hasPresentedPreviewSheet = false
    
    // MARK: Components
    
    private let titleLabel = {
        var style = TextStyle()
        style.typography = .heading2
        style.decoration.foregroundColor = .labelDefault
        
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.text = "BottomSheet Preview"
        return label
    }()
    
    private let descriptionLabel = {
        var style = TextStyle()
        style.typography = .body2
        style.decoration.foregroundColor = .labelSubtle
        
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.textAttributes = style.toDictionary()
        label.text = "컨텐츠 내부 제약이 루트 view의 높이를 만들고, presentation controller는 그 높이를 읽어서 제스처와 애니메이션에만 사용해."
        return label
    }()
    
    private lazy var presentButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .primary)
        let button = SaionButton(with: appearance)
        button.title = "바텀시트 열기"
        button.addTarget(self, action: #selector(presentBottomSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView = UIStackView(
        .vertical,
        alignment: .fill,
        spacing: 16
    )
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !hasPresentedPreviewSheet else { return }
        hasPresentedPreviewSheet = true
        
        DispatchQueue.main.async { [weak self] in
            self?.presentBottomSheet()
        }
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .backgroundSubtle
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(presentButton)
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    @objc private func presentBottomSheet() {
        guard presentedViewController == nil else { return }
        
        let viewController = BottomSheetDemoContentVC()
        present(viewController, animated: true)
    }
}

// MARK: - BottomSheetDemoContentVC

private final class BottomSheetDemoContentVC: BottomSheetPresentationVC {
    
    // MARK: Components
    
    private let handleContainerView = UIView()
    
    private let handleView = {
        let view = UIView()
        view.backgroundColor = .lineStrong
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let titleLabel = {
        var style = TextStyle()
        style.typography = .title1
        style.decoration.foregroundColor = .labelDefault
        
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.text = "컨텐츠 높이로 열리는 시트"
        return label
    }()
    
    private let descriptionLabel = {
        var style = TextStyle()
        style.typography = .body2
        style.decoration.foregroundColor = .labelSubtle
        
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.textAttributes = style.toDictionary()
        label.text = "이 시트는 별도 height constraint 없이 stackView의 top/bottom 제약으로 높이가 결정돼."
        return label
    }()
    
    private let textForm = {
        let form = SaionBoxTextForm()
        form.titleLabel.text = "메모"
        form.textField.placeholder = "키보드 대응도 확인해봐"
        form.captionLabel.text = "키보드가 올라오면 시트 하단이 keyboardLayoutGuide를 따라가."
        return form
    }()
    
    private lazy var closeButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .neutral)
        let button = SaionButton(with: appearance)
        button.title = "닫기"
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView = UIStackView(
        .vertical,
        alignment: .fill,
        spacing: 16,
        inset: .init(top: 12, leading: 20, bottom: 24, trailing: 20)
    )
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(stackView)
        handleContainerView.addSubview(handleView)
        
        stackView.addArrangedSubview(handleContainerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(textForm)
        stackView.addArrangedSubview(closeButton)
        
        stackView.setCustomSpacing(20, after: descriptionLabel)
        stackView.setCustomSpacing(24, after: textForm)
        
        handleView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(36)
            $0.height.equalTo(4)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    BottomSheetDemoVC()
}
