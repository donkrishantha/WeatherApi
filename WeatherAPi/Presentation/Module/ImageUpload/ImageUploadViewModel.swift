//
//  ImageUploadViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import Foundation
import Combine
import OSLog

/// Api request type
enum ImageUploadViewModelRequestType {
    case userVerify
    case imageUpload
}

final class ImageUploadViewModel: ObservableObject {
    
    /// MARK: Output
    @Published private(set) var uploadModel: UploadModel?
    @Published private(set) var imageResponse: ImageResponse?
    @Published private(set) var alertMessage: AlertMessage?
    @Published var showAlert = false
    private let logger = Logger.dataStore
    
    /// MARK: Input
    private(set) var cancelable: Set<AnyCancellable> = []
    private var repository: ImageUploadProtocol?
    //private let weatherApiUseCaseProtocol: WeatherApiUseCaseProtocol?
    private let imageUploadUseCaseProtocol: ImageUploadUseCaseProtocol?
    
    
    /// MARK: Init
    init(repository: ImageUploadProtocol = ImageUploadRepositoryImp(apiClient: APIClient()),
         //weatherApiUseCaseProtocol: WeatherApiUseCaseProtocol,
         imageUploadUseCaseProtocol: ImageUploadUseCaseProtocol) {
        self.repository = repository
        //self.weatherApiUseCaseProtocol = weatherApiUseCaseProtocol
        self.imageUploadUseCaseProtocol = imageUploadUseCaseProtocol
    }
    
    /// MARK: De-Init
    deinit {
        debugPrint("De-Initialisation.")
    }
}

// Make api request
extension ImageUploadViewModel {
    
    /// request data async way
    func verifyTokenTask() {
        Task(priority: .medium) {
            await verifyTokenRequest(requestType: .userVerify)
        }
    }
    
    /// request data async way
    func imageUploadTask(userName: String?, file: Data?) {
        Task(priority: .medium) {
            await imageUploadRequest(requestType: .imageUpload,
                                     userName: userName,
                                     file: file)
        }
    }
    
    /// api request "verifyToken"
    private func verifyTokenRequest(requestType: ImageUploadViewModelRequestType) async {
        let response: AnyPublisher<UploadModel, ApiError>? = await imageUploadUseCaseProtocol?.execute()
        responseHandler(response: response, requestType: requestType)
        /*await repository?.checkTokenVerify()
        response1?.sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponseWith(type: requestType, with: completion)
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.processSuccessResponseWith(type: requestType, and: response)
            }.store(in: &cancelable)*/
    }
    
    /// image upload request "imageUpload"
    private func imageUploadRequest(requestType: ImageUploadViewModelRequestType,
                                    userName: String?,
                                    file: Data?) async {
        let response: AnyPublisher<ImageResponse, ApiError>? = await repository?.updateUserProfile(userName: userName, file: file)
        responseHandler(response: response, requestType: requestType)
        /*await repository?.updateUserProfile(userName: userName, file: file)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponseWith(type: requestType, with: completion)
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.processSuccessResponseWith(type: requestType, and: response)
            }.store(in: &cancelable)*/
    }
    
    private func responseHandler<T: Codable>(response: AnyPublisher<T, ApiError>?,
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
    /// process error response
    private func processErrorResponseWith(type: ImageUploadViewModelRequestType,
                                          with completion: Subscribers.Completion<ApiError>){
        switch completion { case .finished: break; case .failure(let error):
            logger.error("ERROR : \(error)")
            switch type {
            case .userVerify, .imageUpload:
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.alertMessage = AlertMessage(title: "Error!", message: error.errorDescription ?? "N/A")
                }
            }
        }
    }
    
    /// process success response
    private func processSuccessResponseWith<T: Codable>(type: ImageUploadViewModelRequestType,
                                                         and response: T) {
        self.logger.info("SUCCESS:")
        switch type {
        case .userVerify:
            /*DispatchQueue.main.async {
                guard let response = response as? ImageResponse else {
                    return
                }
                self.imageResponse = response as? ImageResponse
            }*/
            Task { @MainActor in
                guard let response = response as? ImageResponse else { return }
                self.imageResponse = response
            }
        case .imageUpload:
            /*
             DispatchQueue.main.async {
                 self.uploadModel = response as? UploadModel
             }
             */
            Task { @MainActor in
                guard let response = response as? UploadModel else { return }
                self.uploadModel = response
            }
        }
    }
}
