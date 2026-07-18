//
//  ConfirmAlertVC.swift
//  DesignSystem
//
//  Created by 신정욱 on 7/19/26.
//

import UIKit

open class ConfirmAlertVC: NoticeAlertVC {
    
    // MARK: Components
    
    public let cancelButton = {
        let button = SaionButton(with: .init(size: .large, variant: .neutral))
        button.title = "취소"
        return button
    }()
    
    // MARK: Life Cycle
    
    public override init(
        acceptVariant: SaionButton.Appearance.Variant = .primary
    ) {
        super.init(acceptVariant: acceptVariant)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        buttonsHStack.insertArrangedSubview(cancelButton, at: 0)
    }
}
