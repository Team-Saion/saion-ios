//
//  PopGesturePolicyHosting.swift
//  Navigation
//
//  Created by 신정욱 on 3/9/26.
//

import UIKit

/// 뷰 컨트롤러별로 Pop 제스처 활성화 여부를 제어하는 정책 프로토콜
public protocol PopGesturePolicyHosting: NavigationControllerPolicyHosting {
    /// Pop 제스처의 시작 여부를 결정
    func gestureRecognizerShouldBegin() -> Bool
}
