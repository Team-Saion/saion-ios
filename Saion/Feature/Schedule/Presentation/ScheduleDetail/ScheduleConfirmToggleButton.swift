//
//  ScheduleConfirmToggle.swift
//  Saion
//
//  Created by 신정욱 on 7/23/26.
//

//import UIKit
//
//import DesignSystem
//
//final class ScheduleConfirmToggleButton: UIButton {
//    
//    // MARK: Properties
//    
//    var title: String? {
//        didSet { setNeedsUpdateConfiguration() }
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        CGSize(width: super.intrinsicContentSize.width, height: 38)
//    }
//    
//    // MARK: Life Cycle
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupDefaults()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: Defaults
//    
//    private func setupDefaults() {
//        var config = UIButton.Configuration.plain()
//        config.background.cornerRadius = Radius.componentMedium
//        config.contentInsets = .init(horizontal: 12)
//        config.image = .scheduleCheck
//        config.imagePadding = 4
//        
//        configuration = config
//    }
//    
//    // MARK: Overrides
//    
//    override func updateConfiguration() {
//        guard var configuration else { return }
//        
//        let foregroundColor: UIColor = isSelected ? .labelInverse : .labelStrong
//        let backgroundColor: UIColor = isSelected ? .grey800 : .common0
//        let strokeColor: UIColor = isSelected ? .clear : .lineSubtle
//        
//        let style = TextStyle(
//            typography: .title3,
//            decoration: .init(foregroundColor: foregroundColor)
//        )
//        configuration.attributedTitle = title.map { style.toAttrStr($0) }
//        configuration.background.backgroundColor = backgroundColor
//        configuration.background.strokeColor = strokeColor
//        configuration.background.strokeWidth = 1
//        
//        self.configuration = configuration
//    }
//}
