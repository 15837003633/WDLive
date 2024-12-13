//
//  WDTabBarController.swift
//  WDLive
//
//  Created by scott on 2024/12/6.
//

import UIKit

class WDTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        addSubChild("Home")
        addSubChild("Discover")
        addSubChild("Chat")
        addSubChild("Profile")
    }

    func addSubChild(_ sbName: String) {
        let storyBoard = UIStoryboard(name: sbName, bundle: Bundle.main)
        guard let subVC = storyBoard.instantiateInitialViewController() else {
            return
        }
        addChild(subVC)
    }

}
