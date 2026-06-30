//
//  AlertVC.swift
//  DesignSystem
//
//  Created by 신정욱 on 6/30/26.
//

import Combine
import UIKit

import SnapKit

class NoticeAlertVC: AlertPresentationVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    let contentsVStack = UIStackView(.vertical, spacing: 6, inset: .init(edges: 22))
    
    let buttonsHStack = {
        let view = UIStackView()
        view.inset = .init(horizontal: 16) + .init(bottom: 16)
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    let titleLabel = {
        let style = TextStyle(
            typography: .title1Strong,
            decoration: .init(foregroundColor: .labelDefault)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel = {
        let style = TextStyle(
            typography: .title3,
            decoration: .init(foregroundColor: .labelSubtle)
        )
        let label = AttributedLabel()
        label.textAttributes = style.toDictionary()
        label.numberOfLines = 3
        return label
    }()
    
    let acceptButton = {
        let appearance = SaionButton.Appearance(size: .large, variant: .neutral)
        let button = SaionButton(with: appearance)
        button.title = "확인"
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(contentsVStack)
        view.addSubview(buttonsHStack)
        
        contentsVStack.addArrangedSubview(titleLabel)
        contentsVStack.addArrangedSubview(descriptionLabel)
        buttonsHStack.addArrangedSubview(acceptButton)
        
        contentsVStack.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(buttonsHStack.snp.top)
        }
        buttonsHStack.snp.makeConstraints {
            $0.top.equalTo(contentsVStack.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
