//
//  TabBar.swift
//  Saion
//
//  Created by 신정욱 on 7/5/26.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

import DesignSystem
import Navigation

/// 탭바 컨트롤러 안에 내재되는 탭바 뷰 그 자체
final class TabBar: BaseTabBar {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 탭바의 고정 높이
    override class var height: CGFloat { 51 }
    
    // MARK: Subjects
    
    /// 선택한 탭 인덱스 서브젝트(출력)
    private let selectedIndexSubject = PassthroughSubject<Int, Never>()
    
    // MARK: Components
    
    /// 버튼들을 담는 컨테이너 뷰
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.inset = .init(horizontal: 10) + .init(top: 8, bottom: 2)
        sv.distribution = .fillEqually
        sv.spacing = 10
        return sv
    }()
    
    /// 탭바 컴포넌트 버튼들
    private var buttons = [TabBarButton]()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        backgroundView.backgroundColor = .gray100
        // 곡률 설정
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundView.layer.cornerRadius = Radius.componentXxlarge
        // 그림자 설정
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.1
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowRadius = 12
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(buttonsHStack)
        buttonsHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Overrides
    
    override func setItems(_ items: [UITabBarItem]?) {
        guard let items else { return }
        
        cancellables.removeAll()
        
        buttonsHStack.arrangedSubviews.forEach {
            buttonsHStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        buttons = items.map { TabBarButton(tabBarItem: $0) }
        
        buttons.forEach { buttonsHStack.addArrangedSubview($0) }
        
        /// 선택된 탭 인덱스를 외부에 전달
        /// - UI 업데이트는 상위 뷰에서 updateUI(with:) 호출로 진행
        Publishers
            .MergeMany(buttons.map { $0.tapWithTagPublisher })
            .sink { [weak self] in self?.selectedIndexSubject.send($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Reactive Interface
    
    /// 선택된 인덱스에 따라 모든 버튼의 UI 상태를 갱신
    func updateUI(_ index: Int) {
        buttons.forEach { $0.updateUI(with: index) }
    }
    
    /// 선택된 탭 인덱스 퍼블리셔
    var selectedIndexPublisher: AnyPublisher<Int, Never> {
        selectedIndexSubject.eraseToAnyPublisher()
    }
}

// MARK: - TabBarButton

private final class TabBarButton: UIButton {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let tabBarItem: UITabBarItem
    
    // MARK: Life Cycle
    
    init(tabBarItem: UITabBarItem) {
        self.tabBarItem = tabBarItem
        super.init(frame: .zero)
        setupDefaults()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.imagePlacement = .top
        config.imagePadding = 1
        configuration = config
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 탭하면 아이콘이 통통 튀는 애니메이션 실행
        self.tapPublisher
            .sink { [weak self] _ in self?.bounceIcon() }
            .store(in: &cancellables)
    }
    
    // MARK: Overrides
    
    override func updateConfiguration() {
        super.updateConfiguration()
        guard var configuration else { return }
        
        let titleForegroundColor: UIColor = isSelected ? .gray900 : .gray400
        let imageForegroundColor: UIColor = isSelected ? .gray900 : .gray300
        
        let style = TextStyle(
            typography: .caption2,
            decoration: .init(foregroundColor: titleForegroundColor)
        )
        
        configuration.image = tabBarItem.image?.withTintColor(imageForegroundColor)
        configuration.attributedTitle = tabBarItem.title.map { style.toAttrStr($0) }
        
        self.configuration = configuration
    }
    
    // MARK: Reactive Interface
    
    /// 탭하면 아이콘이 통통 튀는 애니메이션 실행
    private func bounceIcon() {
        UIView.animateKeyframes(
            withDuration: 0.2,
            delay: 0,
            options: [.calculationModeCubic],
            animations: { [weak imageView] in
                // 살짝 튀어 오르고
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                    imageView?.transform = .init(scaleX: 1.16, y: 1.16)
                }
                // 원래 크기로 복귀
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                    imageView?.transform = .identity
                }
            },
            completion: nil
        )
    }
    
    /// 선택한 인덱스(태그)를 바탕으로 선택 상태 갱신
    func updateUI(with tag: Int) { isSelected = tag == tabBarItem.tag }
    
    /// 탭하면 자신의 태그(인덱스)를 방출하는 퍼블리셔
    var tapWithTagPublisher: AnyPublisher<Int, Never> {
        tapPublisher
            .compactMap { [weak self] in self?.tabBarItem.tag }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { TabBar() }
