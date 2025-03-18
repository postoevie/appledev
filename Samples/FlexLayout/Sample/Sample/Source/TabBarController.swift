//
//  Controller.swift
//  Sample
//
//  Created by Igor Postoev on 7.3.24..
//

import UIKit
import FlexLayout

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        let flexItemsVC = ViewsAssembly.createFlexItemsModule()
        flexItemsVC.title = "Flex Items"
        viewControllers = [flexItemsVC]
    }
}
