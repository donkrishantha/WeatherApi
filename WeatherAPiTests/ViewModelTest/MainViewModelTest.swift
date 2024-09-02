//
//  MainViewModelTest.swift
//  WeatherAPiTests
//
//  Created by Gayan Dias on 15/08/2024.
//

import XCTest
import Combine
@testable import WeatherAPi

final class MainViewModelTest: XCTestCase {

    fileprivate var repository: MockWeatherRepository!
    fileprivate var viewModel: MainViewModel!
    private var cancelable: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        setData()
    }

    override func tearDownWithError() throws {
        repository = nil
        viewModel = nil
        cancelable.forEach {$0.cancel()}
        cancelable.removeAll()
        try super.tearDownWithError()
    }
    
    func setData() {
        self.repository = MockWeatherRepository(sendError: false)
        self.viewModel = MainViewModel(repository: repository)
    }
    
    func test_search_results() {
        /// Given
        let expectation = XCTestExpectation(description: "searchResults")
        let repository = MockWeatherRepository(sendError: false)
        let viewModel = MainViewModel(repository: repository)
        
        /// When
        viewModel.searchText = "New York"
        
        /// Then
        viewModel.$weatherModel
            .sink(receiveValue: { weather in
                if ((weather?.weatherName?.isEmpty) != nil) {
                    expectation.fulfill()
                }
            })
            .store(in: &cancelable)
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_search_results_with_emptyString() {
        /// Given
        let expectation = XCTestExpectation(description: "searchResults")
        let viewModel = MainViewModel(repository: MockWeatherRepository(sendError: false))
        
        /// When
        viewModel.searchText = ""
    
        /// Then
        viewModel.$weatherModel
            .sink(receiveValue: { weather in
                if ((weather?.weatherName?.isEmpty) == nil) {
                    expectation.fulfill()
                }
            })
            .store(in: &cancelable)
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_load_asyncData() async throws {
        /// Given
        let expectation = XCTestExpectation(description: "Load async data!")
        let viewModel = MainViewModel(repository: MockWeatherRepository(sendError: false))
        
        /// When
        viewModel.searchText = "New York"
        
        /// Then
        viewModel.$weatherModel
            .sink(receiveValue: { [weak self] weather in
                guard self != nil else { return }
                if ((weather?.weatherName?.isEmpty) != nil) {
                    XCTAssertEqual(weather?.weatherName, "New York")
                    XCTAssertEqual(weather?.temperature , 28)
                    XCTAssertEqual(weather?.weatherIcon, "https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png")
                    XCTAssertEqual(weather?.observationDate, "2024-08-02 01:27")
                    XCTAssertEqual(weather?.observationTime, "05:27 AM")
                    expectation.fulfill()
                }
            })
            .store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func test_getWeatherDetails() async throws {
        /// Given
        let expectation = XCTestExpectation(description: "Load async data!")
        let repository = MockWeatherRepository(sendError: false)
        let viewModel = MainViewModel(repository: repository)
        
        /// When
        viewModel.searchText = "New York"
        let requestParameters = WeatherDetailParams.init(searchTerm: viewModel.searchText)
        
        /// Then
        await repository.searchWeatherData(params: requestParameters)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] weatherRowData in
                guard self != nil else { return }
                if !weatherRowData.currentLocation.name.isEmpty {
                    XCTAssertEqual(weatherRowData.currentLocation.name, "New York")
                    XCTAssertEqual(weatherRowData.currentWeather.temperature, 28)
                    XCTAssertEqual(weatherRowData.currentWeather.weatherIcon, "https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png")
                    XCTAssertEqual(weatherRowData.currentLocation.localTime, "2024-08-02 01:27")
                    XCTAssertEqual(weatherRowData.currentWeather.observationTime, "05:27 AM")
                    expectation.fulfill()
                }
            })
            .store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func test_getWeatherDetails_With_Error() async throws {
        /// Given
        let expectation = XCTestExpectation(description: "Load async data!")
        let repository = MockWeatherRepository(sendError: true)
        let viewModel = MainViewModel(repository: repository)
        
        /// When
        viewModel.searchText = "New York"
        let requestParameters = WeatherDetailParams.init(searchTerm: viewModel.searchText)
        
        /// Then
        await repository.searchWeatherData(params: requestParameters)
            .sink { [weak self] weather in
                guard self != nil else { return }
                switch weather {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    XCTAssertEqual(error.errorDescription, ApiError.apiError("Error").localizedDescription)
                    expectation.fulfill()
                }
            } receiveValue: { _ in}
            .store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 10)
    }
}

/*
"location": {
    "name": "New York",
    "country": "United States of America",
    "region": "New York",
    "lat": "40.714",
    "lon": "-74.006",
    "timezone_id": "America/New_York",
    "localtime": "2024-08-02 01:27",
    "localtime_epoch": 1722562020,
    "utc_offset": "-4.0"
},
"current": {
    "observation_time": "05:27 AM",
    "temperature": 28,
    "weather_code": 113,
    "weather_icons": [
        "https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png"
    ],
    "weather_descriptions": [
        "Clear "
    ],
    "wind_speed": 9,
    "wind_degree": 251,
    "wind_dir": "WSW",
    "pressure": 1013,
    "precip": 0,
    "humidity": 67,
    "cloudcover": 18,
    "feelslike": 30,
    "uv_index": 1,
    "visibility": 10,
    "is_day": "no"
}
*/
