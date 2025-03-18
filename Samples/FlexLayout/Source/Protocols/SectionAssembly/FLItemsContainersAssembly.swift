//
//  FLSectionBodyAssembly.swift
//  Pods
//
//  Created by Igor Postoev on 18.3.25..
//


/// Builds
public protocol FLItemsContainersAssembly<ItemId> {
    
    associatedtype ItemId
    
    /// <#Description#>
    /// - Parameter cellAssembly: <#cellAssembly description#>
    /// - Returns: <#description#>
    func build(cellAssembly: FLCellAssemblyType) -> (UIView, any FLCellItemsContainer<ItemId>)
}
