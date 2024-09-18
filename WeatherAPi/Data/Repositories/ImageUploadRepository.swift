//
//  ImageUploadRepository.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import Foundation
import Combine

protocol ImageUploadProtocol {
    
    func checkTokenVerify() async -> AnyPublisher<UploadModel, ApiError>
    func updateUserProfile(userName: String?, file: Data?) async -> AnyPublisher<ImageResponse, ApiError>
    
    //func updateUserProfile(userName: String?, file: Data?) async -> AnyPublisher<WeatherRowData, ApiError>
    //func upload(data: Data, fileName: String, mediaType: String) -> Promise<Int>
    //func upload(image: UIImage, withName name: String) -> Promise<Int>    
    //func upload(data: Data, fileName: String, mediaType: String) async -> AnyPublisher<WeatherRowData, ApiError>
}

struct ImageUploadRepositoryImp: ImageUploadProtocol {
    
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func checkTokenVerify() async -> AnyPublisher<UploadModel, ApiError> {
        let endpoint = ImageUploadEndpoint.checkUserVerify
        let request = RequestModel(endPoint: endpoint, method: .get)
        return await apiClient.request(request, responseModel: UploadModel.self)
    }
    
    func updateUserProfile(userName: String?, file: Data?) async -> AnyPublisher<ImageResponse, ApiError> {
        let endPoint = EventsEndpoints.updateUserProfile(userName: userName, file: file)
        let request = RequestModel(endPoint: endPoint, method: .post)
        return await apiClient.upload(request, responseModel: ImageResponse.self)
    }
    
    /*
    func updateUserProfile(userName: String?, file: Data?) async -> AnyPublisher<WeatherRowData, ApiError> {
        let endPoint = EventsEndpoints.updateUserProfile(userName: userName, file: file)
        let request = RequestModel(endPoint: endPoint, method: .post)
        //let uploadData = endPoint.uploadData
        return await apiClient.request(request, responseModel: WeatherRowData.self)
    }

    func upload(data: Data, fileName: String, mediaType: String) async -> AnyPublisher<WeatherRowData, ApiError> {
        let endPoint = EventsEndpoints.updateUserProfile(userName: fileName, file: data)
        let request = RequestModel(endPoint: endPoint, method: .post)
        return await apiClient.upload(request, responseModel: WeatherRowData.self)
    }*/
        
        /*
        func upload(data: Data, fileName: String, mediaType: String) -> Promise<Int> {
            let formData = MultipartFormData()
            formData.append(data, withName: "multipart", fileName: fileName, mimeType: mediaType)

            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "public", value: "false"),
                URLQueryItem(name: "fileName", value: fileName),
                URLQueryItem(name: "mediaType", value: mediaType)
            ]

            return firstly { () -> Promise<ResponseDTO<FileDTO>> in
                privateNetwork.upload(formData, with: Route(.post, .files(with: queryItems)))
            }
            .map(\.data.id)
        }*/
         
        /*
        func upload(image: UIImage, withName name: String) -> Promise<Int> {
            let fileName = "\(name).jpeg"

            guard let data = image.jpegData(
                resizeImageTo: CGSize(dimensions: 2000),
                maxSizeInMB: 0.5,
                initialCompressionQuality: 0.7
            ) else {
                return Promise(error: FileUploadError.failedToProcessImage)
            }

            return upload(data: data, fileName: fileName, mediaType: "image/jpeg")
        }*/
}
