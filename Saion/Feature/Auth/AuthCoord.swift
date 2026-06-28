//
//  AuthCoord.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import UIKit

final class AuthCoord: Coordinator {
    func start() {
        let vc = LoginVC()
        navigation.pushViewController(vc, animated: false)
    }
}
