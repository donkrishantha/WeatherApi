//
//  DependencyContainer.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 04/09/2024.
//

/*
 Dependency Injection (DI) is a design technique where an object receives its required dependencies from an external source, rather than creating them internally.
 */

import Foundation

final class DependencyContainer {
    
    /*static let shared = DependencyContainer()

    private var services: [String: Any] = [:]

    func register<T>(_ service: T) {
        services[String(describing: T.self)] = service
    }

    func resolve<T>(_ serviceType: T.Type) -> T? {
        services[String(describing: T.self)] as? T
    }*/
    
    private lazy var urlSession = URLSession(
        configuration: URLSessionConfiguration.default
    )

    private lazy var apiClient: APIClient = APIClient(
        session: urlSession
    )
    
    private(set) lazy var weatherApiRepository: any WeatherApiRepoProtocol = WeatherApiRepoImplement(
        apiClient: apiClient
    )
}

/*
 class DependencyContainer {
     private var registry = [String: () -> Any]()

     func register<T>(_ type: T.Type, factory: @escaping () -> T) {
         let key = String(describing: type)
         registry[key] = factory
     }

     func resolve<T>(_ type: T.Type) -> T {
         let key = String(describing: type)
         guard let factory = registry[key] as? () -> T else {
             fatalError("No registered entry for \(T.self)")
         }
         return factory()
     }
 }
 //---------------------------------------
 enum DependencyError: Error {
     case dependencyNotRegistered(String)
 }

 class DependencyContainer {
     private var registry = [String: () -> Any]()

     func register<T>(_ type: T.Type, factory: @escaping () -> T) {
         let key = String(describing: type)
         registry[key] = factory
     }

     func resolve<T>(_ type: T.Type) throws -> T {
         let key = String(describing: type)
         guard let factory = registry[key]?() as? T else {
             throw DependencyError.dependencyNotRegistered("No registered entry for \(T.self)")
         }
         return factory()
     }
 }
 //---------------------------------------
 
 */
