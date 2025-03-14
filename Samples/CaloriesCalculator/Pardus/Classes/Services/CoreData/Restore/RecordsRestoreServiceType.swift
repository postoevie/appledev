//
//  CoreDataRecordsRestoreServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

protocol RecordsRestoreServiceType {
    
    func restoreRecords(snapshot: RecordsStateSnapshot)
}
