//
//  ImageUploadViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import Foundation
import Combine
import OSLog

enum ImageUploadViewModelRequestType {
    case userVerify
    case imageUpload
}

final class ImageUploadViewModel: ObservableObject {
    
    // MARK: Output
    @Published private(set) var uploadModel: UploadModel?
    @Published private(set) var imageResponse: ImageResponse?
    @Published private(set) var alertMessage: AlertMessage?
    @Published var showAlert = false
    private let logger = Logger.dataStore
    
    // MARK: Input
    private(set) var cancelable: Set<AnyCancellable> = []
    private var repository: ImageUploadProtocol?
    
    // MARK: Init
    init(repository: ImageUploadProtocol = ImageUploadRepositoryImp(apiClient: APIClient())) {
        self.repository = repository
    }
    
    // MARK: De-Init
    deinit {
        debugPrint("De-Initialisation.")
    }
}

// Make api request
extension ImageUploadViewModel {
    
    /// request data async way
    func verifyTokenRequest() {
        Task(priority: .medium) { await verifyToken(requestType: .userVerify) }
    }
    
    func imageUploadRequest(userName: String?, file: Data?) {
        Task(priority: .medium) { await imageUpload(requestType: .imageUpload, userName: userName, file: file) }
    }
    
    /// api request "verifyToken"
    private func verifyToken(requestType: ImageUploadViewModelRequestType) async {
        await repository?.checkTokenVerify()
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponseWith(type: requestType, with: completion)
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.processSuccessResponseWith(type: .userVerify, and: response)
            }.store(in: &cancelable)
    }
    
    /// image upload request "imageUpload"
    private func imageUpload(requestType: ImageUploadViewModelRequestType, userName: String?, file: Data?) async {
        await repository?.updateUserProfile(userName: userName, file: file)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponseWith(type: requestType, with: completion)
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.processSuccessResponseWith(type: .imageUpload, and: response)
            }.store(in: &cancelable)
    }
}

// Handel request responses & errors
extension ImageUploadViewModel {
    /// process error in response
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
    
    /// process error in response
    private func processSuccessResponseWith<T: Codable >(type: ImageUploadViewModelRequestType,
                                                         and response: T) {
        self.logger.info("SUCCESS:")
        switch type {
        case .userVerify:
            self.imageResponse = response as? ImageResponse
        case .imageUpload:
            self.uploadModel = response as? UploadModel
        }
    }
}
