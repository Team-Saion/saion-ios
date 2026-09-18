import UIKit

import Kingfisher
import SnapKit

import DesignSystem

final class ProfileImageView: UIImageView {
    
    // MARK: Properties
    
    /// 사이즈 구성 컨테이너
    private let sizeMetrics: ProfileImageViewSizeMetrics
    
    // MARK: Components
    
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
    
    // MARK: Defaults
    
    private func setupDefaults() {
        contentMode = .scaleAspectFill
        
        layer.cornerRadius = sizeMetrics.size.width / 2
        clipsToBounds = true
        
        backgroundColor = .backgroundDefault
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(initialLabel)
        
        self.snp.makeConstraints { $0.size.equalTo(sizeMetrics.size) }
        initialLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: Configure
    
    func configure(with state: ProfileImageViewState) {
        // 상태 적용 전처리
        initialLabel.isHidden = true
        image = nil
        
        // 실제 상태 적용
        switch state {
        case .image(let profileImageURL):
            kf.setImage(with: profileImageURL)
            
        case .fallback(let name, let avatarColor):
            initialLabel.text = name
            initialLabel.isHidden = false
            
            backgroundColor = avatarColor
        }
    }
}

// MARK: - View State

enum ProfileImageViewState: Hashable {
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
    
    init(from domain: MyProfile) {
        if let profileImageURL = domain.profileImageURL {
            self = .image(profileImageURL: profileImageURL)
        } else {
            let hexString = domain.avatarColor.hex.trimmingCharacters(
                in: CharacterSet(charactersIn: "#")
            )
            let avatarColor = Int(hexString, radix: 16)
                .map { UIColor.hex($0) } ?? .black
            
            self = .fallback(
                name: String(domain.nickname.prefix(2)),
                avatarColor: avatarColor
            )
        }
    }
}
