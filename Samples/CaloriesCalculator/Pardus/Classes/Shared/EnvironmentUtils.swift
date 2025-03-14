//
//  LaunchUtils.swift
//  Pardus
//
//  Created by Igor Postoev on 17.11.24..
//

import Foundation

enum EnvironmentUtils {
    
    static var isInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static var isInUITests: Bool {
        ProcessInfo.processInfo.arguments.contains(Const.UITests.argumentKey)
    }
    
    static var uiTestsViewSnapshotPath: String? {
        ProcessInfo.processInfo.environment[Const.UITests.viewSnapshotPathKey]
    }
    
    static var uiTestsDataSnapshotPath: String? {
        ProcessInfo.processInfo.environment[Const.UITests.dataSnapshotPathKey]
    }
}
