//
//  SaionTextButton.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/17/26.
//

import UIKit

public final class SaionTextButton: UIButton {
    
    // MARK: Properties
    
    /// 버튼의 크기, 색상, 이미지 등 스타일 사양을 정의하는 디자인 토큰 객체
    public let appearance: SaionTextButton.Appearance
    
    /// 버튼 표시 텍스트
    /// 값 변경 시 버튼 설정 업데이트 요청
    public var title: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    // MARK: Components
    
    /// 하이라이트 및 비활성화 상태에서 적용되는 색상 오버레이 레이어
    private let overlayLayer = CALayer()
    
    // MARK: Life Cycle
    
    public init(with appearance: SaionTextButton.Appearance) {
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
        
        config.imagePlacement = .trailing
        config.imagePadding = 2
        
        config.background.backgroundColor = .clear
        config.contentInsets = .init(vertical: 2) + .init(leading: 6, trailing: 4)
        config.background.cornerRadius = Radius.componentSmall
        config.cornerStyle = .fixed
        
        configuration = config
        clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() { layer.addSublayer(overlayLayer) }
    
    // MARK: Overrides
    
    public override func updateConfiguration() {
        guard var configuration else { return }
        
        /// 상태별 오버레이 색상
        let overlayColor: UIColor = switch state {
        case .highlighted:  appearance.variant.overlayColor.highlighted
        case .disabled:     appearance.variant.overlayColor.disabled
        default:            appearance.variant.overlayColor.normal
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
        
        /// 상태별 포그라운드 색상
        let foregroundColor = switch state {
        case .highlighted:  appearance.variant.foregroundColor.highlighted
        case .disabled:     appearance.variant.foregroundColor.disabled
        default:            appearance.variant.foregroundColor.normal
        }
        
        // 타이틀 스타일 반영
        configuration.attributedTitle = title.map {
            var style = TextStyle()
            style.typography = appearance.size.typography
            style.decoration.foregroundColor = foregroundColor
            return style.toAttrStr($0)
        }
        
        // 이미지 스타일 반영
        configuration.image = appearance.variant.image?
            .resized(to: appearance.size.imageSize)
            .withTintColor(foregroundColor)
        
        self.configuration = configuration
    }
}

// MARK: - UIImage

extension UIImage {
    /// 쉐브론 아이콘 리사이징 목적의 확장 헬퍼 메서드
    fileprivate func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return resizedImage.withRenderingMode(renderingMode)
    }
}

// MARK: - Preview

#Preview {
    let appearance = SaionTextButton.Appearance(size: .large, variant: .chevron)
    let button = SaionTextButton(with: appearance)
    button.title = "버튼입니당"
//        button.isEnabled = false
//        button.title = "근데 비활성화된.."
    return button
}


