//
//  PhotoCaptureView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 01/10/2024.
//

import SwiftUI

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var image: Image?
    
    var body: some View {
        //ImagePicker2(isShown: $showImagePicker, image: $image)
        Text("kqwjdhuiwdh")
    }
}

#if DEBUG
struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(Image("")))
    }
}
#endif
