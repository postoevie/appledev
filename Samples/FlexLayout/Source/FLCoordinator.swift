//
//  FLCoordinator.swift
//  FlexLayout
//
//  Created by user on 6.2.24..
//

public final class FLCoordinator {
    
    let viewAssemply: FLViewAssembly
    
    public init(sections: [FLSection],
                actionsDelegate: FLViewActionsDelegate?) {
        self.viewAssemply = FLViewAssembly(sections: sections,
                                           actionsDelegate: actionsDelegate)
    }
    
    /// Creates views and its' interactors
    /// - Returns: Array of structs containing views and interactors
    public func buildSectionViews() -> [FLSectionViewResult]  {
        return viewAssemply.build()
    }
}
