//
//  NetworkAvailabilityService.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 3.3.25..
//

// TODO: Update tests, inversion of networkMonitor

import Combine
import Network

protocol NetworkAvailabilityReponder: AnyObject {
    
    func networkAvailabilityStatusChanged(status: NetStatus)
}

protocol NetworkAvailabilityServiceType: AnyObject {
    
    func start()
}

typealias NetStatus = NWPath.Status

final class NetworkAvailabilityService: @unchecked Sendable, ObservableObject, NetworkAvailabilityServiceType {
    
    @Published var netStatus: NetStatus = .unsatisfied
    
    private let networkMonitor = NWPathMonitor()
    private let serviceQueue = DispatchQueue(label: "cryptoTracker.networkAvailabilityService")
    
    private var subscriptions: [AnyCancellable] = []
    private var isRunning = false
    
    func start() {
        serviceQueue.async {
            guard self.isRunning == false else {
                return
            }
            self.isRunning = true
            self.networkMonitor.pathUpdateHandler = { [weak self] path in
                self?.netStatus = path.status
            }
            self.networkMonitor.start(queue: self.serviceQueue)
        }
    }
    
    func subscribe(_ responder: NetworkAvailabilityReponder) {
        $netStatus
            .receive(on: serviceQueue)
            .removeDuplicates()
            .sink { [weak responder] status in
                responder?.networkAvailabilityStatusChanged(status: status)
            }
            .store(in: &subscriptions)
    }
}
