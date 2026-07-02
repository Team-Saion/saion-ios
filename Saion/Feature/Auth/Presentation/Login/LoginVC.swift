//
//  LoginVC.swift
//  Saion
//
//  Created by 신정욱 on 6/26/26.
//

import Combine
import UIKit

import CasePaths
import CombineCocoa
import SnapKit

import DesignSystem

final class LoginVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = AuthDI.shared.makeLoginVM()
    
    // MARK: Components
    
    private let logoImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = .authLogo
        return view
    }()
    
    private let loginButton = {
        let appearance = SaionButton.Appearance(
            size: .xlarge,
            variant: .init(
                foregroundColor: .labelDefault,
                backgroundColor: .hex(0xFFEB00)
            ),
            image: .authKakao,
            imagePlacement: .leading
        )
        
        let button = SaionButton(with: appearance)
        button.title = "카카오로 시작하기"
        return button
    }()
    
    private let backgroundLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.backgroundSubtle.cgColor,
            UIColor.yellow50.cgColor
        ]
        layer.locations = [0.4, 1.0]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundLayer.frame = view.bounds
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.layer.addSublayer(backgroundLayer)
        
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(156)
            $0.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        vm.send(.viewDidLoad)
        
        loginButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.kakaoLoginTapped) }
            .store(in: &cancellables)
        
        vm.effectPublisher
            .compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 약관 동의 시트 노출
    private func presentTermsSheet() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let sheet = TermsSheetVC()
            
            sheet.submitPublisher
                .sink { [weak sheet] in
                    sheet?.dismiss(animated: true) { promise(.success(())) }
                }
                .store(in: &sheet.cancellables)
            
            self?.present(sheet, animated: true)
        } }
        .eraseToAnyPublisher()
    }
    
    /// 프로필 입력 화면으로 이동 퍼블리셔
    var pushProfileInputPublisher: AnyPublisher<Void, Never> {
        vm.effectPublisher
            .compactMap { $0[case: \.presentTerms] }
            .compactMap { [weak self] in self?.presentTermsSheet() }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { LoginVC() }
