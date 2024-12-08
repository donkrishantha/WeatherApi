//
//  WeatherStation.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 19/11/2024.
//

import Foundation

// Test Observere pattern
protocol WeatherObserver: AnyObject {
    func update(temp: Double, humidity: Double, pressure: Double)
}

class WeatherStation {
    var temperature: Double = 0.0
    var humidity: Double = 0.0
    var pressure: Double = 0.0
    var observers: [WeatherObserver] = []

    func registerObserver(_ observer: WeatherObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: WeatherObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func notifyObservers() {
        for observer in observers {
            observer.update(temp: temperature, humidity: humidity, pressure: pressure)
        }
    }

    func setMeasurements(temp: Double, humidity: Double, pressure: Double) {
        self.temperature = temp
        self.humidity = humidity
        self.pressure = pressure
        notifyObservers()
    }
    
    deinit {
        observers.removeAll()
    }
}
