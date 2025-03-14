//
//  RootInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24.
//  
//

import Foundation

final class RootInteractor: RootInteractorProtocol {
    
    let restoreRecordsService: RecordsRestoreServiceType
    let memoryPressureService: MemoryPressureServiceType
    
    init(restoreRecordsService: RecordsRestoreServiceType,
         memoryPressureService: MemoryPressureServiceType) {
        self.restoreRecordsService = restoreRecordsService
        self.memoryPressureService = memoryPressureService
    }
    
    func startMemoryPressureObservation() {
        memoryPressureService.start()
    }
    
    func restoreRecords() {
        guard let uiTestDataPath = EnvironmentUtils.uiTestsDataSnapshotPath,
              let uiTestData = FileManager.default.contents(atPath: uiTestDataPath) else {
            return
        }
        do {
            let snapshot = try JSONDecoder().decode(RecordsStateSnapshot.self, from: uiTestData)
            restoreRecordsService.restoreRecords(snapshot: snapshot)
        } catch {
            print(error) // TODO: P-58
        }
    }
}
