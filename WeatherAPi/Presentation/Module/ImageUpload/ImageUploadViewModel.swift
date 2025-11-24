//
//  ImageUploadViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import Foundation
import Combine
import OSLog
import Network

/// Api request type
enum ImageUploadViewModelRequestType {
    case userVerify
    case imageUpload
}

protocol ImageUploadViewModelOutputProtocol {
    // MARK: Input
    var uploadModel: UploadModel? { get }
    var imageResponse: ImageResponse? { get }
    var alertMessage: AlertMessage? { get }
    var showAlert: Bool { get }
    var logger: Logger { get }
}

protocol ImageUploadViewModelInputProtocol {
    // MARK: Output
    func verifyTokenTask()
    func imageUploadTask(userName: String?, file: Data?)
}

protocol defaultImageUploadViewModel: ImageUploadViewModelOutputProtocol, ImageUploadViewModelOutputProtocol {}

final class ImageUploadViewModel: ObservableObject {
    
    /// MARK: Output
    @Published private(set) var uploadModel: UploadModel?
    @Published private(set) var imageResponse: ImageResponse?
    @Published private(set) var alertMessage: AlertMessage?
    @Published var showAlert = false
    internal let logger = Logger.dataStore
    
    private(set) var isLoading = false
    
    /// MARK: Input
    private(set) var cancelable: Set<AnyCancellable> = []
    private let repository: ImageUploadProtocol?
    private let imageUploadUseCaseProtocol: ImageUploadUseCaseProtocol?
    
    
    /// MARK: Init
    init(repository: ImageUploadProtocol,
         imageUploadUseCaseProtocol: ImageUploadUseCaseProtocol) {
        self.repository = repository
        self.imageUploadUseCaseProtocol = imageUploadUseCaseProtocol
    }
    
    /// MARK: De-Init
    deinit {
        debugPrint("De-Initialisation.")
    }
}

// Make api request
extension ImageUploadViewModel {
    
    /// api request "verifyToken"
    /// - Parameter requestType: generic request type
    func verifyTokenRequest(requestType: ImageUploadViewModelRequestType) async {
//        if Task.isCancelled {return}
//        try? Task.checkCancellation()
        guard !isLoading else { return }
        defer { isLoading = false }
        isLoading = true
        let response: AnyPublisher<UploadModel, APIError>? = await imageUploadUseCaseProtocol?.execute()
        responseHandler(response: response, requestType: requestType)
    }
    
    
    /// image upload request "imageUpload"
    /// - Parameters:
    ///   - requestType: generic request type
    ///   - userName: input parameter
    ///   - file: input parameter
    func imageUploadRequest(requestType: ImageUploadViewModelRequestType,
                                    userName: String?,
                                    file: Data?) async {
        let response: AnyPublisher<ImageResponse, APIError>? = await repository?.updateUserProfile(userName: userName,
                                                                                                   file: file)
        responseHandler(response: response, requestType: requestType)
    }
    
    
    /// Handel the response  in generally
    /// - Parameters:
    ///   - response: api response
    ///   - requestType: type of the response
    private func responseHandler<T: Codable>(response: AnyPublisher<T, APIError>?,
                         requestType: ImageUploadViewModelRequestType) {
        response?.sink { [weak self] completion in
            guard let self = self else { return }
            self.processErrorResponseWith(type: requestType, with: completion)
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.processSuccessResponseWith(type: requestType, and: response)
        }.store(in: &cancelable)
    }
}

// Handel request responses & errors
extension ImageUploadViewModel {
    
    /// Process error response  generally
    /// - Parameters:
    ///   - type: response  type
    ///   - completion: response model
    private func processErrorResponseWith(type: ImageUploadViewModelRequestType,
                                          with completion: Subscribers.Completion<APIError>){
        switch completion { case .finished: break; case .failure(let error):
            logger.error("ERROR : \(error)")
            switch type {
            case .userVerify, .imageUpload:
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.alertMessage = AlertMessage(title: "Error!",
                                                     message: error.errorDescription ?? "N/A")
                }
            }
        }
    }
    
    
    /// Process success response  generally
    /// - Parameters:
    ///   - type: response  type
    ///   - response: response model
    private func processSuccessResponseWith<T: Codable>(type: ImageUploadViewModelRequestType,
                                                         and response: T) {
        self.logger.info("SUCCESS:")
        switch type {
        case .userVerify:
            Task { @MainActor in // DispatchQueue.main.async {}
                guard let response = response as? ImageResponse else { return }
                self.imageResponse = response
            }
        case .imageUpload:
            Task { @MainActor in // DispatchQueue.main.async {}
                guard let response = response as? UploadModel else { return }
                self.uploadModel = response
            }
        }
    }
}
