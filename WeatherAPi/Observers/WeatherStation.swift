//
//  WeatherStation.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 19/11/2024.
//

import Foundation

// Notification type
enum UpdateState {
    case updateComplete
    case moderateComplete
}

// Observer (protocol)
protocol ObserverProtocol: AnyObject {
    func update(temp: Double, humidity: Double, pressure: Double)
    func moderate(temp: Double, humidity: Double, pressure: Double)
}

// Subject (protocol)
protocol SubjectProtocol {
    func registerObserver(_ observer: ObserverProtocol)
    func removeObserver(_ observer: ObserverProtocol)
    func notifyObservers(status: UpdateState)
}

// Concrete Subject
class Subject: SubjectProtocol {
    var temperature: Double = 0.0
    var humidity: Double = 0.0
    var pressure: Double = 0.0
    var observers: [ObserverProtocol] = []

    /// Add observer
    func registerObserver(_ observer: ObserverProtocol) {
        observers.append(observer)
    }

    /// Remove Observer
    func removeObserver(_ observer: ObserverProtocol) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    /// Notify Observer
    func notifyObservers(status: UpdateState) {
        for observer in observers {
            switch status {
            case .updateComplete:
                observer.update(temp: temperature, humidity: humidity, pressure: pressure)
            case .moderateComplete:
                observer.moderate(temp: temperature, humidity: humidity, pressure: pressure)
            }
            
        }
    }

    /// Additional function
    func setMeasurements(temp: Double, humidity: Double, pressure: Double) {
        self.temperature = temp
        self.humidity = humidity
        self.pressure = pressure
        notifyObservers(status: .updateComplete)
    }
    
    /// Additional function
    func setModerate(temp: Double, humidity: Double, pressure: Double) {
        self.temperature = temp
        self.humidity = humidity
        self.pressure = pressure
        notifyObservers(status: .moderateComplete)
    }
    
    deinit {
        observers.removeAll()
    }
}
