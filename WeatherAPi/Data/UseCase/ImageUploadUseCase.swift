//
//  ImageUploadUseCase.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 19/10/2025.
//

import Foundation
import Combine
import Network

protocol ImageUploadUseCaseProtocol {
    func execute() async -> AnyPublisher<UploadModel, APIError>
}

final class ImageUploadUseCase {
    private let imageUploadRepository: ImageUploadProtocol?
    
    init(imageUploadRepository: ImageUploadProtocol) {
        self.imageUploadRepository = imageUploadRepository
    }
}
    
extension ImageUploadUseCase: ImageUploadUseCaseProtocol {
    func execute() async -> AnyPublisher<UploadModel, APIError> {
        let result = await imageUploadRepository?.checkTokenVerify()
        return result!
    }
}

