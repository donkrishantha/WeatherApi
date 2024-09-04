
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [
                                Color("AccentColor"),
                                Color("AppBackground"),
                                Color("AccentColor"),
                            ]), startPoint: .top, endPoint: .bottomTrailing)

            VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundVIew_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct VisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
        VisualEffectView()
    }
}
