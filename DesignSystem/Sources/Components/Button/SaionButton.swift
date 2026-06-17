//
//  SaionButton.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/17/26.
//

import UIKit

/// 디자인 시스템 공통 커스텀 버튼 컴포넌트
/// UIButton.Configuration 및 SaionButton.Appearance 기반으로 동작
public final class SaionButton: UIButton {
    
    // MARK: Properties
    
    /// 버튼의 크기, 색상, 이미지 등 스타일 사양을 정의하는 디자인 토큰 객체
    public let appearance: SaionButton.Appearance
    
    /// 버튼 표시 텍스트
    /// 값 변경 시 버튼 설정 업데이트 요청
    public var title: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    // MARK: Components
    
    /// 하이라이트 및 비활성화 상태에서 적용되는 색상 오버레이 레이어
    private let overlayLayer = CALayer()
    
    // MARK: Life Cycle
    
    public init(with appearance: SaionButton.Appearance) {
        self.appearance = appearance
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        overlayLayer.frame = bounds
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        // UIButton.Configuration 기반의 인셋, 이미지, 기본 배경색 등 기본 UI 속성 설정
        var config = UIButton.Configuration.plain()
        
        config.image = appearance.image?.withTintColor(appearance.variant.foregroundColor)
        config.imagePlacement = appearance.imagePlacement
        config.imagePadding = 4
        
        config.background.backgroundColor = appearance.variant.backgroundColor
        config.contentInsets = appearance.size.contentInset
        config.cornerStyle = .capsule
        
        configuration = config
        clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        layer.addSublayer(overlayLayer)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: appearance.size.height)
        ])
    }
    
    // MARK: Overrides
    
    public override func updateConfiguration() {
        guard var configuration else { return }
        
        /// 상태별 오버레이 색상
        let overlayColor: UIColor = switch state {
        case .highlighted:  .overlayPressed
        case .disabled:     .overlayDisabled
        default:            .clear
        }
        
        /// 상태별 스케일
        let scale: CGAffineTransform = switch state {
        case .highlighted:  CGAffineTransform(scaleX: 0.95, y: 0.95)
        case .disabled:     .identity
        default:            .identity
        }
        
        // 상태 변경 애니메이션 반영
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [
                .beginFromCurrentState,
                .allowUserInteraction,
                .curveEaseOut,
            ],
            animations: { [weak self] in
                self?.overlayLayer.backgroundColor = overlayColor.cgColor
                self?.transform = scale
            }
        )
        
        /// 타이틀 스타일 반영
        var titleStyle = TextStyle()
        titleStyle.typography = appearance.size.typography
        titleStyle.decoration.foregroundColor = appearance.variant.foregroundColor
        configuration.attributedTitle = title.map { titleStyle.toAttrStr($0) }
        
        self.configuration = configuration
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    let appearance = SaionButton.Appearance(size: .large, variant: .neutral)
    let button = SaionButton(with: appearance)
    button.title = "버튼입니당"
    //    button.isEnabled = false
    //    button.title = "근데 비활성화된.."
    return button
}
