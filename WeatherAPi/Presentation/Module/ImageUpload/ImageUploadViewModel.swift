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
    case imageUpload(Void)
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
    
    
    init(repository: ImageUploadProtocol = ImageUploadRepositoryImp(apiClient: APIClient())) {
        self.repository = repository
    }
    
    deinit {
        debugPrint("De-Initialisation.")
    }
}

extension ImageUploadViewModel {
    
    /// request data async way
    func loadAsyncData(requestType: ImageUploadViewModelRequestType) {
        switch requestType {
        case .userVerify:
            Task(priority: .medium) { await verifyToken(requestType: .userVerify) }
        case .imageUpload: break
           // Task(priority: .medium) { await imageUpload(requestType: \\}\\\\\\\\\\
        }
    }
    
    func uploadImageData(userName: String?, file: Data?) {
        
    }
    
    /// api request
    func verifyToken(requestType: ImageUploadViewModelRequestType) async {
        await repository?.checkTokenVerify()
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(with: completion)
            } receiveValue: { [weak self] uploadResponse in
                guard let self = self else { return }
                self.uploadModel = uploadResponse
            }.store(in: &cancelable)
    }
    
    /// image upload
    func imageUpload(requestType: ImageUploadViewModelRequestType, userName: String?, file: Data?) async {
        await repository?.updateUserProfile(userName: userName, file: file)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(with: completion)
            } receiveValue: { [weak self] imageResponse in
                guard let self = self else { return }
                self.logger.info("SUCCESS:")
                self.imageResponse = imageResponse
            }.store(in: &cancelable)
    }
}


extension ImageUploadViewModel {
    /// process error in further
    private func processErrorResponse(with completion: Subscribers.Completion<ApiError>) {
        switch completion { case .finished: break; case .failure(let error):
            logger.error("ERROR : \(error)")
            DispatchQueue.main.async {
                self.showAlert = true
                self.alertMessage = AlertMessage(title: "Error!", message: error.errorDescription ?? "N/A")
            }
        }
    }
}
