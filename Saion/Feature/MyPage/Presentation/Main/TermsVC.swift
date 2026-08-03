//
//  TermsVC.swift
//  Saion
//
//  Created by 신정욱 on 8/3/26.
//

import Combine
import SafariServices
import UIKit

import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

final class TermsVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, spacing: 28, inset: .init(edges: 20))
    
    private let termsButton = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelDefault)
        )
        var config = UIButton.Configuration.plain()
        config.attributedTitle = style.toAttrStr("서비스 이용약관 동의")
        config.contentInsets = .zero
        config.imagePlacement = .trailing
        config.image = .chevronRightMedium
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let privacyButton = {
        let style = TextStyle(
            typography: .body1,
            decoration: .init(foregroundColor: .labelDefault)
        )
        var config = UIButton.Configuration.plain()
        config.attributedTitle = style.toAttrStr("개인정보수집 및 이용 동의")
        config.contentInsets = .zero
        config.imagePlacement = .trailing
        config.image = .chevronRightMedium
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
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
        defaultNavBar.titleLabel.text = "약관 확인"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(termsButton)
        mainVStack.addArrangedSubview(privacyButton)
        
        mainVStack.snp.makeConstraints { $0.top.horizontalEdges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 서비스 이용약관 상세 버튼 탭 시 해당 링크 웹페이지 사파리 표시
        termsButton.tapPublisher
            .map { "https://sites.google.com/view/saio-terms-service-v1-0/홈?authuser=8" }
            .sink { [weak self] in self?.openSafari(url: $0) }
            .store(in: &cancellables)
        
        // 개인정보 수집 및 이용 상세 버튼 탭 시 해당 링크 웹페이지 사파리 표시
        privacyButton.tapPublisher
            .map { "https://sites.google.com/view/saio-terms-personalinfo-v1-0/홈?authuser=8" }
            .sink { [weak self] in self?.openSafari(url: $0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 주어진 URL을 Safari 뷰 컨트롤러로 열기
    private func openSafari(url: String) {
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true)
    }
}

// MARK: - Preview

#Preview { TermsVC() }
