//
//  HomeCoord.swift
//  Saion
//
//  Created by 신정욱 on 7/10/26.
//

import UIKit

import Navigation

final class HomeCoord: Coordinator {
    
    // MARK: Start
    
    func start() {
        let vc = HomeVC()
        navigation.pushViewController(vc, animated: false)
    }
}
