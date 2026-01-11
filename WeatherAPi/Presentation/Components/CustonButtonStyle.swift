////
////  CustonButtonStyle.swift
////  WeatherAPi
////
////  Created by Gayan Dias on 24/12/2025.
////
//
//import Foundation
//import SwiftUI
//
//struct Custom {}
//
//extension Custom {
//    
//     enum ButtonVariant {
//         case progressType
//         case sendButton
//         case logInButton
//    }
//    
//    struct ButtonStyle: SwiftUI.ButtonStyle {
////        @Environment(\.isAppLoading) var isAppLoading : Bool
////        @Environment(\.appButtonTag) var appButtonTag : ButtonTags
////        @Environment(\.controlSize) var controlSize
////        var variant: ButtonVariant
//        
//        let variant: ButtonVariant
//        
//        func makeBody(configuration: Configuration) -> some View {
//           /* switch variant {
//            case .logIn:
//                HStack {
//                    Spacer()
//                    Image(systemName: "camera.metering.center.weighted")
//                    Text("\(appButtonTag)")
//                    Divider()
//                    configuration.label
//                        //.foregroundColor(.black)
//                        .font(.headline)
//                    Spacer()
//                }
//                .padding()
//                //.background(.green)
//                .foregroundColor(.white)
//                .background(Color.blue.cornerRadius(8))
//                //.scaleEffect(configuration.isPressed ? 0.95 : 1)
//                .opacity((isAppLoading && appButtonTag == .logIn) ? 0.5 : 1)
//                .allowsHitTesting((isAppLoading && appButtonTag == .logIn) ? false : true)
////                .overlay {
////                    CircularProgressView(isLoading: isAppLoading)
////                }
//            case .sendButton:
//                HStack {
//                    //Spacer()
//                    Image(systemName: "paperplane")
//                    Text("\(appButtonTag)")
//                    Divider()
//                    configuration.label
//                        //.foregroundColor(.black)
//                        .font(.headline)
//                   // Spacer()
//                }
//                .padding()
//                //.background(.green)
//                .foregroundColor(.white)
//                .background(Color.green.cornerRadius(8))
//                //.scaleEffect(configuration.isPressed ? 0.95 : 1)
//                .opacity((isAppLoading && appButtonTag == .send) ? 0.5 : 1)
//                .allowsHitTesting((isAppLoading && appButtonTag == .send) ? false : true)
////                .overlay {
////                        CircularProgressView(isLoading: isAppLoading)
////                }
//            case .progressType:
//                configuration.label
//                    .padding()
//                    .background(.green)
//                    .foregroundColor(.white)
//                    //.cornerRadius(10)
//                    .opacity(configuration.isPressed ? 0.5 : 1)
//                    .overlay {
//                        CircularProgressView(isLoading: isAppLoading)
//                            //.offset(x : -10)
//                    }
//            }*/
//            ButtonContent(label: configuration.label, variant: variant)
//        }
//    }// end ButtonStyle
//    
//    struct CustomButtonStyle: SwiftUI.ButtonStyle {
//        @Environment(\.isEnabled) var isEnabled
//        @Environment(\.isAppLoading) var isAppLoading : Bool
//        @Environment(\.appButtonTag) var appButtonTag : ButtonTags
//        func makeBody(configuration: Configuration) -> some View {
//            configuration.label
//                HStack {
//                    //Spacer()
//                    Image(systemName: "paperplane")
//                    //Text("\(appButtonTag)")
//                    Divider()
//                    configuration.label
//                        //.foregroundColor(.black)
//                        .font(.headline)
//                   // Spacer()
//                }
//                .padding()
//                //.background(.green)
//                .foregroundColor(.white)
//                .background(Color.green.cornerRadius(8))
//                //.scaleEffect(configuration.isPressed ? 0.95 : 1)
//                .opacity((isAppLoading) ? 0.5 : 1)
//                .allowsHitTesting((isAppLoading) ? false : true)
//                .overlay {
//                        CircularProgressView(isLoading: isAppLoading)
//                }
//        }
//    }
//}
//
//extension Custom {
//    struct ButtonContent<Label: View>: View {
//        @Environment(\.isAppLoading) var isAppLoading : Bool
//        @Environment(\.appButtonTag) var appButtonTag : ButtonTags
//        @Environment(\.controlSize) var controlSize
//        
//        let label: Label
//        let variant: ButtonVariant
//        
//        var body: some View {
//            switch variant {
//            case .logInButton:
//                HStack {
//                    Spacer()
//                    Image(systemName: "camera.metering.center.weighted")
//                    Text("\(appButtonTag) \(isAppLoading)")
//                    Divider()
//                    label
//                        //.foregroundColor(.black)
//                        .font(.headline)
//                    Spacer()
//                }
//                .padding()
//                //.background(.green)
//                .foregroundColor(.white)
//                .background(Color.blue.cornerRadius(8))
//                //.scaleEffect(configuration.isPressed ? 0.95 : 1)
//                .opacity((isAppLoading && appButtonTag == .logIn) ? 0.5 : 1)
//                .allowsHitTesting((isAppLoading && appButtonTag == .logIn) ? false : true)
//                .overlay {
//                    CircularProgressView(isLoading: isAppLoading)
//                }
//            case .sendButton:
//                HStack {
//                    //Spacer()
//                    Image(systemName: "paperplane")
//                    Text("\(appButtonTag) \(isAppLoading)")
//                    Divider()
//                    label
//                        //.foregroundColor(.black)
//                        .font(.headline)
//                   // Spacer()
//                }
//                .padding()
//                //.background(.green)
//                .foregroundColor(.white)
//                .background(Color.green.cornerRadius(8))
//                //.scaleEffect(configuration.isPressed ? 0.95 : 1)
//                .opacity((isAppLoading && appButtonTag == .send) ? 0.5 : 1)
//                .allowsHitTesting((isAppLoading && appButtonTag == .send) ? false : true)
////                .overlay {
////                        CircularProgressView(isLoading: isAppLoading)
////                }
//            case .progressType:
//                label
//                    .padding()
//                    .background(.green)
//                    .foregroundColor(.white)
//                    //.cornerRadius(10)
//                    //.opacity(configuration.isPressed ? 0.5 : 1)
//                    .overlay {
//                        CircularProgressView(isLoading: isAppLoading)
//                            //.offset(x : -10)
//                    }
//            }
//        }
//    }
//}
//
//extension Custom {
//    // The button action triggers on double taps.
//    struct DoubleTapStyle: PrimitiveButtonStyle {
//      func makeBody(configuration: Configuration) -> some View {
//        Button(configuration) // <- Button instead of configuration.label
//          .onTapGesture(count: 2, perform: configuration.trigger)
//      }
//    }
//}
//
//extension ButtonStyle where Self == Custom.ButtonStyle {
//    static func custom(variant: Custom.ButtonVariant) -> Self {
//        .init(variant: variant)
//    }
//}
//
//extension ButtonStyle where Self == Custom.CustomButtonStyle {
//    static var CustomButtonStyle: Self {
//        .init()
//    }
//}
//
///*func getPadding() -> EdgeInsets {
//    @Environment(\.controlSize) var controlSize
//    let unit:CGFloat = 4
//    switch controlSize {
//        case .regular:
//            return EdgeInsets(top: unit * 2, leading: unit * 4, bottom: unit * 2, trailing: unit * 4)
//        case .large:
//            return EdgeInsets(top: unit * 3, leading: unit * 5, bottom: unit * 3, trailing: unit * 5)
//        case .mini:
//            return EdgeInsets(top: unit / 2, leading: unit * 2, bottom: unit/2, trailing: unit * 2)
//        case .small:
//            return EdgeInsets(top: unit, leading: unit * 3, bottom: unit, trailing: unit * 3)
//        case .extraLarge:
//            return EdgeInsets(top: unit, leading: unit * 3, bottom: unit, trailing: unit * 3)
//        @unknown default:
//            fatalError()
//    }
//}
//
//func getFontSize() -> Font {
//    @Environment(\.controlSize) var controlSize
//    switch controlSize {
//        case .regular:
//            return .body
//        case .large:
//            return .title3
//        case .small:
//            return .callout
//        case .mini:
//            return .caption2
//        case .extraLarge:
//            return .caption2
//        @unknown default:
//            fatalError()
//    }
//}*/
