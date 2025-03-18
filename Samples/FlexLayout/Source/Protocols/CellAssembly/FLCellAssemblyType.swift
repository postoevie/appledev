//
//  FLCellAssemblyType.swift
//  Pods
//
//  Created by Igor Postoev on 18.3.25..
//


public protocol FLCellAssemblyType {
    
    func buildContentConfig(item: any FLCellItemType) -> UIContentConfiguration
    func buildBackgroundConfig(item: any FLCellItemType) -> UIBackgroundConfiguration
}