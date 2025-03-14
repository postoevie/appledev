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

final class NetworkAvailabilityService: ObservableObject, NetworkAvailabilityServiceType {
    
    @Published private var netStatus: NetStatus?
    private let networkMonitor = NWPathMonitor()
    private let networkMonitorQueue = DispatchQueue(label: "cryptoTracker.networkMonitor")
    
    private var subscriptions: [AnyCancellable] = []
    private var isStarted = false
    
    func start() {
        guard isStarted == false else {
            netStatus = networkMonitor.currentPath.status // Update instead of start
            return
        }
        isStarted = true
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.netStatus = path.status
        }
        networkMonitor.start(queue: networkMonitorQueue)
    }
    
    func subscribe(_ responder: NetworkAvailabilityReponder) {
        $netStatus
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak responder] status in
                responder?.networkAvailabilityStatusChanged(status: status)
            }
            .store(in: &subscriptions)
    }
}
