//
//  Const.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

enum Const {
    
    enum UserDefaults {
        
        static let viewsSnapshotKey = "pardus.viewsSnapshotKey"
        static let recordsSnapshotKey = "pardus.recordsSnapshotKey"
    }
    
    enum UITests {
        
        static let argumentKey = "--uitesting"
        static let viewSnapshotPathKey = "UITEST_VIEW_PATH"
        static let dataSnapshotPathKey = "UITEST_DATA_PATH"
    }
}
