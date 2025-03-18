//
//  FlexItemsController.swift
//  Sample
//
//  Created by Igor Postoev on 15.3.25..
//

import UIKit

final class FlexItemsController: UIViewController {
   
   var presenter: FlexItemsPresenter?
   
   override func viewDidLoad() {
       super.viewDidLoad()
       view.backgroundColor = .white
   }
   
   func addChildAndSetView(controller: UIViewController) {
       addChild(controller)
       view.addSubview(controller.view)
       controller.view.snp.makeConstraints {
           $0.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
       }
   }
}
