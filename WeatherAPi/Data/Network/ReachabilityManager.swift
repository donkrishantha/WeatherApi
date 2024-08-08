//
//  ReachabilityManager.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 26/06/2024.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    let monitor = NWPathMonitor()
    @Published public private(set) var isConnected: Bool = false
    private var hasStatus: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            #if targetEnvironment(simulator)
                if (!self.hasStatus) {
                    self.isConnected = path.status == .satisfied
                    self.hasStatus = true
                } else {
                    self.isConnected = !self.isConnected
                }
            #else
                self.isConnected = path.status == .satisfied
            #endif
            print("isConnected: " + String(self.isConnected))
        }
        monitor.start(queue: queue)
    }
}

class NetworkStatus: ObservableObject {
    static let shared = NetworkStatus()
    private var monitor: NWPathMonitor?
    private var queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let status = path.status == .satisfied
                self?.isConnected = status
                print(">>> \(path.status)")
            }
        }

        monitor?.start(queue: queue)
    }

    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}

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

public class NetworkReachability {

    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }

    let backgroudQueue = DispatchQueue.global(qos: .background)

    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }

    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
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

