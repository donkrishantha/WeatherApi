//
//  ImageView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 17/04/2024.
//

import SwiftUI

struct ImageView: View {
    
    var imageUrl: String?
    var size: CGFloat?
    private let transaction: Transaction = .init(animation: .linear)
    
    var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: URL(string: imageUrl ?? ""), transaction: transaction) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.yellow
                        ProgressView()
                    }
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(let error):
                    Image(systemName: "xmark.octagon.fill")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                        .font(.title3)
                @unknown default:
                    Text("Unknown")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: size, height: size)
            .cornerRadius(8)
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    ImageView()
}
