//
//  CircularProgressView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 03/12/2025.
//

import SwiftUI

@frozen public struct CircularProgressView: View {
    
    //let progress: CGFloat? = 0.0
    var isLoading: Bool? = false
    //@Binding var isLoading: Bool
    let loaderAnimationSpeed: LoaderAnimation? = .medium
    let progress: Double? = 2.0
    
    //    init(isLoading: Bool, loaderAnimationSpeed: LoaderAnimation, progress: Double) {
    //        self.isLoading = isLoading
    //        self.loaderAnimationSpeed = loaderAnimationSpeed
    //        self.progress = progress
    //    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(Color.pink.opacity(0.5),lineWidth: 6)
                .opacity(isLoading ?? false ? 1 : 0)
            Circle()
                //.trim(from: 0.0, to: Double(min(progress, 1.0)))
                .trim(from: 0.0, to: 0.75)
                .stroke(Color.pink, style: StrokeStyle(
                        lineWidth: 6,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .rotationEffect(.degrees(isLoading ?? false ? 360 : 0))
                .animation(Animation.linear(duration: isLoading ?? false ? loaderAnimationSpeed?.animationSpeed ?? 0.0 : 0)
                    .repeatForever(autoreverses: false),
                           value: isLoading)
                .opacity(isLoading ?? false ? 1 : 0)
            
            /*Circle()
             .stroke(lineWidth: 5)
             .opacity(0.3)
             .foregroundColor(Color(UIColor.systemGray3))
             
             // green base circle to receive shadow
             Circle()
             //.trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .trim(from: 0.0, to: 0.75)
                 .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                 .foregroundColor(Color(UIColor.systemGreen))
                 //.rotationEffect(Angle(degrees: 270.0))
                 .rotationEffect(.degrees(isLoading ?? false ? 360 : 0))
             
             // point with shadow, clipped
             Circle()
             //.trim(from: CGFloat(abs((min(progress, 1.0))-0.001)), to: CGFloat(abs((min(progress, 1.0))-0.0005)))
                .trim(from: 0.0, to: 0.75)
                 .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                 .foregroundColor(Color(UIColor.blue))
                 .shadow(color: .black, radius: 10, x: 0, y: 0)
                 //.rotationEffect(Angle(degrees: 270.0))
                 .rotationEffect(.degrees(isLoading ?? false ? 360 : 0))
                 .animation(Animation.linear(duration: isLoading ?? false ? loaderAnimationSpeed?.animationSpeed ?? 0.0 : 0)
                 .repeatForever(autoreverses: false),
                               value: isLoading)
             .clipShape(
                Circle().stroke(lineWidth: 5)
             )
             
             // green overlay circle to hide shadow on one side
             Circle()
                //.trim(from: progress > 0.5 ? 0.25 : 0, to: CGFloat(min(self.progress, 1.0)))
                .trim(from: 0.0, to: 0.75)
                 .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                 .foregroundColor(Color(UIColor.systemGreen))
                 //.rotationEffect(Angle(degrees: 270.0))
                 .rotationEffect(.degrees(isLoading ?? false ? 360 : 0))
                 .animation(Animation.linear(duration: isLoading ?? false ? loaderAnimationSpeed?.animationSpeed ?? 0.0 : 0)
                 .repeatForever(autoreverses: false),
                            value: isLoading)*/
        }
        .frame(width: 20, height: 20)
    }
}

public enum LoaderAnimation {
    case low, medium, high, non
    
    var animationSpeed: Double {
        switch self {
        case .low: return 1.0
        case .medium: return 0.8
        case .high: return 10.2
        case .non: return 0.0
        }
    }
}

#if DEBUG
struct CircularProgressView_Preview: PreviewProvider {
    static var previews: some View {
        CircularProgressView(isLoading: true)
    }
}
#endif


