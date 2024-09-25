//
//  ImageUploadContentView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import SwiftUI

struct ImageUploadContentView: View {
    
    @ObservedObject var viewModel: ImageUploadViewModel
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("No image selected")
                }
                
                Button(action: {
                    viewModel.verifyTokenRequest()
                }) {
                    Text("Verify User")
                }
                
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Select Image")
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertMessage?.title ?? "A/A"),
                      message: Text(viewModel.alertMessage?.message ?? "N/A"),
                      dismissButton: .default(Text("Got it!")))
            }
            .navigationTitle("Update profile")
            .padding([.leading, .trailing], 15)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showImagePicker)
            }
        }
    }
}

struct ImageUploadContentView_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = ImageUploadViewModel()
        ImageUploadContentView(viewModel: viewModel)
    }
}
