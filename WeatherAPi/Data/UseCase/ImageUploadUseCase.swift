//
//  ImageUploadUseCase.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 19/10/2025.
//

import Foundation
import Combine

protocol ImageUploadUseCaseProtocol {
    func execute() async -> AnyPublisher<UploadModel, ApiError>
    //func execute2() async -> Result<UploadModel, ApiError>
}

final class ImageUploadUseCase: ImageUploadUseCaseProtocol {
    
    private let imageUploadRepository: ImageUploadProtocol?
    
    init(imageUploadRepository: ImageUploadProtocol) {
        self.imageUploadRepository = imageUploadRepository
    }
    
    func execute() async -> AnyPublisher<UploadModel, ApiError> {
        let result = await imageUploadRepository?.checkTokenVerify()
        return result!
    }
    
//    func execute2() async -> Result<UploadModel, ApiError> {
//        let result = (await imageUploadRepository?.checkTokenVerify())!
//        return result
//    }
}
