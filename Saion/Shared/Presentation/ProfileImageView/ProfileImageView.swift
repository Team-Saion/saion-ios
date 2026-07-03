import UIKit

import Kingfisher
import SnapKit

import DesignSystem

final class ProfileImageView: UIImageView {
    
    // MARK: Properties
    
    /// 사이즈 구성 컨테이너
    private let sizeMetrics: ProfileImageViewSizeMetrics
    
    // MARK: Components
    
    /// 내부 그림자 레이어
    private let innerShadowLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: -20)
        layer.shadowRadius = 20
        layer.fillRule = .evenOdd
        layer.isHidden = true
        return layer
    }()
    
    /// 폴백 이니셜 레이블
    private lazy var initialLabel = {
        let style = TextStyle(
            typography: sizeMetrics.typography,
            decoration: .init(foregroundColor: .labelInverse)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.isHidden = true
        return label
    }()
    
    // MARK: Life Cycle
    
    init(size sizeMetrics: ProfileImageViewSizeMetrics) {
        self.sizeMetrics = sizeMetrics
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateInnerShadow()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        contentMode = .scaleAspectFill
        
        layer.cornerRadius = sizeMetrics.size.width / 2
        clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(initialLabel)
        layer.addSublayer(innerShadowLayer)
        
        self.snp.makeConstraints { $0.size.equalTo(sizeMetrics.size) }
        initialLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: UpdateInnerShadow
    
    private func updateInnerShadow() {
        innerShadowLayer.frame = bounds
        
        let cornerRadius = layer.cornerRadius
        
        // 외곽 사각형 영역 설정 (그림자 반경보다 넉넉하게 마진 설정)
        let outerRect = bounds.insetBy(
            dx: -innerShadowLayer.shadowRadius * 2.0,
            dy: -innerShadowLayer.shadowRadius * 2.0
        )
        let path = UIBezierPath(rect: outerRect)
        
        // 내부 둥근 사각형 영역을 반대 방향으로 추가하여 구멍을 뚫음
        let innerPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).reversing()
        path.append(innerPath)
        
        innerShadowLayer.path = path.cgPath
        innerShadowLayer.shadowPath = path.cgPath
        
        // 안쪽 그림자만 잘 보이도록 마스크 설정
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
        
        innerShadowLayer.mask = maskLayer
    }
    
    // MARK: Configure
    
    func configure(with state: ProfileImageViewState) {
        // 상태 적용 전처리
        innerShadowLayer.isHidden = true
        initialLabel.isHidden = true
        image = nil
        
        // 실제 상태 적용
        switch state {
        case .image(let profileImageURL):
            kf.setImage(with: profileImageURL)
            
        case .fallback(let name, let avatarColor):
            innerShadowLayer.shadowColor = avatarColor.withAlphaComponent(0.5).cgColor
            innerShadowLayer.isHidden = false
            
            initialLabel.text = name
            initialLabel.isHidden = false
            
            backgroundColor = avatarColor
        }
    }
}

// MARK: - View State

enum ProfileImageViewState {
    /// 프로필 사진이 있음
    case image(profileImageURL: URL)
    /// 프로필 사진이 없는 경우 폴백 UI 노출
    case fallback(name: String?, avatarColor: UIColor)
    
    init(from domain: OnboardingInfo) {
        if let profileImageURL = domain.profileImageURL {
            self = .image(profileImageURL: profileImageURL)
            
        } else {
            self = .fallback(
                name: String(domain.nickname?.prefix(2) ?? ""),
                avatarColor: domain.avatarColor
            )
        }
    }
}
