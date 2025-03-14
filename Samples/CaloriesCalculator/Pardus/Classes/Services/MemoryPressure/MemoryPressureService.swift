//
//  MemoryPressureService.swift
//  Pardus
//
//  Created by Igor Postoev on 5.1.25..
//

import Dispatch

class MemoryPressureService: MemoryPressureServiceType {
    
    private let dispatchSource = DispatchSource.makeMemoryPressureSource(eventMask: [.warning, .critical])
    
    private let coreDataStackService: CoreDataStackServiceType
    
    init(coreDataStackService: CoreDataStackServiceType) {
        self.coreDataStackService = coreDataStackService
    }
    
    func start() {
        dispatchSource.setEventHandler { [weak self] in
            guard let self,
                  self.dispatchSource.isCancelled == false else {
                return
            }
            let event = self.dispatchSource.data
            do {
                switch event {
                case .warning:
                    print("MemoryPressureMonitor: Low memory warning")
                case.critical:
                    print("MemoryPressureMonitor: Critical memory warning")
                    try self.persistMainContext()
                default: break
                }
            } catch {
                print(error) // TODO: P-58
            }
        }
        dispatchSource.activate()
    }
    
    private func persistMainContext() throws {
        try coreDataStackService.getMainQueueContext().persist()
    }
    
    deinit {
        dispatchSource.cancel()
    }
}
