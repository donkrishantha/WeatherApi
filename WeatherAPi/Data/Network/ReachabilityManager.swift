//
//  ReachabilityManager.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 26/06/2024.
//

import Foundation
import Network

/*extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [.other, .wifi, .cellular, .loopback, .wiredEthernet]
}

final class ReachabilityManager: ObservableObject {
    
    static let shared = ReachabilityManager()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    @Published var currentInterface: NWInterface.InterfaceType = .wifi
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func start() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            guard let interface = NWInterface.InterfaceType.allCases.filter({ path.usesInterfaceType($0)}).first else {
                return
            }
            
            DispatchQueue.main.async {
                self?.currentInterface = interface
            }
        }
    }
    
    func stop() {
        
    }
}*/

enum NewNetworkStatus {
    case undetermined
    case notConnected
    case connected
}

protocol NetworkPathMonitorProtocol {
    var pathUpdateHandler: ((_ newPath: NWPath.Status) -> Void)? { get set }
    func start(queue: DispatchQueue)
    func cancel()
}

final class NetworkPathMonitor : NetworkPathMonitorProtocol {
    var pathUpdateHandler: ((NWPath.Status) -> Void)?
    let monitor: NWPathMonitor

    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let owner = self else { return }
            owner.pathUpdateHandler?(path.status)
        }
    }

    func start(queue: DispatchQueue) {
        monitor.start(queue: queue)
    }

    func cancel() {
        monitor.cancel()
    }
}

/*
class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    var isConnected: Bool = false
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
            NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}*/

//final class AppViewModel: ObservableObject {
//    @Published var networkStatus: NewNetworkStatus = .undetermined
//    var networkMonitor: NetworkPathMonitorProtocol
//
//    public init(networkMonitor: NetworkPathMonitorProtocol) {
//        self.networkMonitor = networkMonitor
//        self.networkMonitor.pathUpdateHandler = { [weak self] status in
//            DispatchQueue.main.async { [weak self] in
//                self?.networkStatus = status == .satisfied ? .connected : .notConnected
//            }
//        }
//        self.networkMonitor.start(queue: DispatchQueue.global())
//    }
//
//    deinit {
//        networkMonitor.cancel()
//    }
//}

