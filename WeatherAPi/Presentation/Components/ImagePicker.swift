//
//  ImagePicker.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 01/10/2024.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    init(selectedImage: Binding<UIImage?>, isPresented: Binding<Bool>) {
        _selectedImage = selectedImage
        _isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = uiImage
            isPresented = false
            // call web service to upload the image
            
            guard let selectedImg = selectedImage!.pngData() else {
                print("Image not found")
                return
            }
            
            var multipart = MultipartRequest()
            multipart.add(key: "file", fileName: "test.png", fileMimeType: "image/png", fileData: selectedImg)
            
//            let img: Data = selectedImg
//            let base64: String = img.base64EncodedString()
//            let rebornImg = base64.imageFromBase64
            
            //var base64d: Data = selectedImg
            let imageData: Data = selectedImage!.pngData()!
            var imageSize: Int = imageData.count
            //print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
            
            ///---------------------------
            /////Convert image to Base 64 String
            let imageStringData = convertImageToBase64(image: selectedImage!)
            //print("IMAGE base64 String: \(imageStringData)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isPresented = false
    }
}

struct ImagePicker3: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker3>) {
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(selectedImage: $selectedImage, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker3>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
}

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

/*class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    init(isShown: Binding<Bool>, image: Binding<Image?>) {
        _isShown = isShown
        _image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = Image(uiImage: uiImage)
        isShown = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct ImagePicker2: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker2>) {
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker2>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}*/
