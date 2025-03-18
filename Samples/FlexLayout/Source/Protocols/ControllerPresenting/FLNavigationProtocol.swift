//
//  FLControllerPresentationProtocol.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.3.24..
//

/// Enables presenting view controllers
public protocol FLNavigationProtocol: AnyObject {
    
    func presentInPopover(_ controller: UIViewController, sender: UIView, size: CGSize)
}
