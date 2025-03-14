//
//  FLSectionController+Presenting.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.3.24..
//

extension FLSectionController: FLNavigationProtocol,
                               UIPopoverPresentationControllerDelegate {
    
    // MARK: - FLControllerPresentationProtocol
    
    func presentInPopover(_ controller: UIViewController, sender: UIView, size: CGSize) {
        DispatchQueue.main.async {
            self.performPresentation(controller, sender: sender, size: size)
        }
    }
    
    private func performPresentation(_ controller: UIViewController, sender: UIView, size: CGSize) {
        guard sender.isDescendant(of: view) else {
            assertionFailure()
            return
        }
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = size
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: false)
        }
        controller.modalPresentationStyle = .popover
        if let popover = controller.popoverPresentationController {
            popover.sourceView = sender
            popover.delegate = self
            popover.permittedArrowDirections = [.any]
        }
        present(controller, animated: true)
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    /// Present UIViewCOntroller with UIModalPresentationPopover style on iPhone as on iPad
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
