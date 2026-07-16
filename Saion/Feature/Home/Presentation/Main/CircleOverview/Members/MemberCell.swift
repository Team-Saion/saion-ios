//
//  MemberCell.swift
//  Saion
//
//  Created by 신정욱 on 7/15/26.
//

import UIKit

import DesignSystem

import SnapKit

final class MemberCell: UICollectionViewCell {
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, alignment: .center, spacing: 8)
    
    private let profileImageView = ProfileImageView(size: .medium)
    
    private let nameLabel = {
        let style = TextStyle(
            typography: .label1Subtle,
            decoration: .init(foregroundColor: .labelSubtle)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(profileImageView)
        mainVStack.addArrangedSubview(nameLabel)
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configure
    
    func configure(with item: MemberCellItem?) {
        if let profileImageViewState = item?.profileImageViewState {
            profileImageView.configure(with: profileImageViewState)
        }
        nameLabel.text = item?.name
    }
}

// MARK: - Presentation Model

struct MemberCellItem: Hashable {
    /// 구성원 ID
    let memberID: String
    /// 화면에 표시할 구성원 이름
    let name: String
    /// 프로필 이미지의 표시 상태
    let profileImageViewState: ProfileImageViewState
}

extension MemberCellItem {
    /// 구성원 요약 정보로 셀 아이템 생성
    init(_ member: MemberSummary) {
        let profileImageViewState: ProfileImageViewState
        
        // 프로필 이미지가 있으면 원격 이미지를 표시
        if let profileImageURL = member.profileImageURL {
            profileImageViewState = .image(profileImageURL: profileImageURL)
        } else {
            // 이미지가 없으면 닉네임과 아바타 색상으로 폴백 UI 구성
            let hexString = member.avatarColor.trimmingCharacters(
                in: CharacterSet(charactersIn: "#")
            )
            let avatarColor = Int(hexString, radix: 16)
                .map { UIColor.hex($0) } ?? .black
            profileImageViewState = .fallback(
                name: String(member.nickname.prefix(2)),
                avatarColor: avatarColor
            )
        }
        
        memberID = member.memberID
        name = member.nickname
        self.profileImageViewState = profileImageViewState
    }
}

// MARK: - Preview

#Preview {
    let cell = MemberCell(frame: .init(x: 0, y: 0, width: 64, height: 93))
    cell.configure(with: .init(
        memberID: "0",
        name: "쭈님",
        profileImageViewState: .fallback(
            name: "쭈님",
            avatarColor: .systemBlue
        )
    ))
    return cell
}
