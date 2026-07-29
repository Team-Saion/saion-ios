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
    
    /// 로그인 화면 상단 로고
    private let logoImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = .authLogo
        return view
    }()
    
    /// 카카오 로그인을 요청하는 버튼
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
    
    /// 화면 전체에 표시되는 세로 방향 그라디언트
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
        // 화면 크기 변경 시 그라디언트 영역을 현재 뷰 크기에 맞춤
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
        // 기존 로그인 정보에 따라 이어서 진행할 온보딩 화면 확인
        vm.send(.viewDidLoad)
        
        // 카카오 로그인 버튼 탭 이벤트 전달
        loginButton.tapPublisher
            .sink { [weak self] in self?.vm.send(.kakaoLoginTapped) }
            .store(in: &cancellables)
        
        // 약관 동의 완료 후 프로필 입력에 필요한 정보 요청
        vm.effect.compactMap { $0[case: \.presentTerms] }
            .compactMap { [weak self] in self?.presentTermsSheet() }
            .switchToLatest()
            .sink { [weak self] in self?.vm.send(.submitTapped) }
            .store(in: &cancellables)
        
        // 상태 전이 중 발생한 에러 알림 표시
        vm.effect.compactMap { $0[case: \.presentError] }
            .sink { [weak self] in self?.presentErrorAlert(error: $0) }
            .store(in: &cancellables)
        
        // 비동기 요청 진행 상태에 따라 로딩 인디케이터 표시
        vm.$state.map(\.isLoading).removeDuplicates()
            .sink { [weak self] in self?.setLoadingIndicatorVisible($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 약관 동의 시트 노출
    private func presentTermsSheet() -> AnyPublisher<Void, Never> {
        Deferred { [weak self] in Future { promise in
            let sheet = TermsSheetVC()
            
            sheet.termsAgreementCompletedPublisher
                .sink { [weak sheet] in
                    sheet?.dismiss(animated: true) { promise(.success(())) }
                }
                .store(in: &sheet.cancellables)
            
            self?.present(sheet, animated: true)
        } }
        .eraseToAnyPublisher()
    }
    
    /// 프로필 입력 화면으로 이동 퍼블리셔
    var pushProfileInputPublisher: AnyPublisher<OnboardingInfo, Never> {
        vm.effect.compactMap { $0[case: \.pushProfileInput] }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { LoginVC() }
