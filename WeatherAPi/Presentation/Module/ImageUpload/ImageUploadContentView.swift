//
//  ImageUploadContentView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import SwiftUI

struct ImageUploadContentView: View {
    
    @ObservedObject var viewModel: ImageUploadViewModel
    //@State private var selectedImage: UIImage? = nil
    //@State private var showImagePicker: Bool = false
    
    ///  Open camera view properties
    //@State private var showImagePicker: Bool = false
    //@State private var image: Image? = nil
    
    /// 2 example
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image2: UIImage?
    
    var body: some View {
        NavigationView{
            /*VStack {
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
             
             Button(action: {
             // select camera
             }) {
             Text("Open Camera")
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
             }*/
            
            VStack {
                Image(uiImage: image2 ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .cornerRadius(15.0)
                Button("Choose Picture") {
                    //self.showSheet = true
                    viewModel.verifyTokenTask()
                }.padding()
                    .actionSheet(isPresented: $showSheet) {
                        UIDevice.isSimulator() ? (
                            ActionSheet(title: Text("Select Photo"), message: Text("Choose"),
                                        buttons: [.default(Text("Photo Library")) {
                                                self.showImagePicker = true
                                                self.sourceType = .photoLibrary
                                            }
                                        ])) : (ActionSheet(title: Text("Select Photo"), message: Text("Choose"),
                                                           buttons: [.default(Text("Photo Library")) {
                                            self.showImagePicker = true
                                            self.sourceType = .photoLibrary
                                        },
                                                                     .default(Text("Camera")) {
                                                                         self.showImagePicker = true
                                                                         self.sourceType = .camera
                                                                     },
                                                                     .cancel()
                                                                    ]))
                    }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertMessage?.title ?? "A/A"),
                      message: Text(viewModel.alertMessage?.message ?? "N/A"),
                      dismissButton: .default(Text("Got it!")))
            }
            .sheet(isPresented: self.$showImagePicker) {
                ImagePicker3(selectedImage: self.$image2,
                             isPresented: self.$showImagePicker,
                             sourceType: self.sourceType)
            }
        }
    }
}

#if DEBUG
struct ImageUploadContentView_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = ImageUploadViewModel()
        ImageUploadContentView(viewModel: viewModel)
    }
}
#endif
