//
//  MainContentView2.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 03/01/2026.
//

import SwiftUI
import Network

enum MainModelButtonTags {
    case delete
    case download
    case send
    case login
    case register
    case attach
    case unknown
}

final class MainModel: ObservableObject {
    
    @Published var loadingTask: Task<Void, Never>?
    @Published var isLoading: Bool = false
    //var isLoading2: Bool { loadingTask != nil }
    
    init() {}
    
    func performWork() {
        guard loadingTask == nil else {
            return
        }
        
        checkCancellation()
        if Task.isCancelled { return }
        loadingTask = Task(priority: .background) {
            try? await request()

            await MainActor.run {
                isLoading = false
                loadingTask = nil
            }
        }
    }
    
    private func request() async throws{
        await MainActor.run {
            isLoading = true
        }
        //try? await Task.sleep(nanoseconds: 1_000_000_000)
        for i in 1...2 {
            print("loop: \(i), isLoading: \(isLoading)")
            if Task.isCancelled { return }
            try Task.checkCancellation() // its realy importent
            sleep(1)
            //try? Task.checkCancellation()
            await Task.yield()
        }
    }
    
    func checkCancellation() {
        print("Task cancelled")
        loadingTask?.cancel()
        loadingTask = nil
        //try? Task.checkCancellation()
    }
}

struct MainContentView2: View {
    
    @ObservedObject private var viewModel: MainModel
    @State var buttonTag: MainModelButtonTags = .unknown
    
    init(viewModel: MainModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            //------------------------
            Button { action(.delete) }
            label: { label(.delete) }
            .buttonStyle(GeneralButtonStyle(tag: $buttonTag, bgColor: .red))
            .environment(\.appButtonTags, .delete)
            
            //------------------------
            Button {action(.download)}
            label: {label(.download)}
            .buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .orange))
            .environment(\.appButtonTags, .download)
            //-----------------------
            Button {action(.login)}
            label: {label(.login)}
            .buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .green))
            .environment(\.appButtonTags, .login)
            //-----------------------
            Button {action(.register)}
            label: {label(.register)}
            .buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .blue))
            .environment(\.appButtonTags, .register)
            //-----------------------
            Button {action(.attach) }
            label: {label(.attach)}
            .buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .blue))
            .environment(\.appButtonTags, .attach)
            //-----------------------
            Button { action(.send) }
            label: {label(.send)}
            .buttonStyle(GeneralButtonStyle(tag: $buttonTag, bgColor: .purple))
            .environment(\.appButtonTags, .send)
            .frame(height: 55)
            //----------------------
            
            Spacer()
        }// end VStack
        .padding()
        .onDisappear {
            viewModel.loadingTask?.cancel()
            viewModel.loadingTask = nil
        }
    }
    
    @ViewBuilder
    private func label(_ tag: MainModelButtonTags) -> some View {
        switch tag {
        case .delete:
            view(title: "Delete")
        case .download:
            view(icon: "square.and.arrow.down", title: "Image download")
        case .send:
            view(icon: "flashlight.off.fill", title: "Cancel Task")
        case .login:
            view(icon: "envelope.fill", title: "Login", hidePadding: true)
        case .register:
            view(icon: "pencil", title: "Registra", hidePadding: true)
        case .attach:
            Image(systemName: "swift")
        case .unknown:
            view(title: "Delete")
        }
    }
    
    private func action(_ tag: MainModelButtonTags) {
        switch tag {
        case .delete:
            viewModel.checkCancellation()
        case .download:
            viewModel.performWork()
        case .send:
            viewModel.checkCancellation()
        case .login:
            viewModel.performWork()
        case .register:
            viewModel.performWork()
        case .attach:
            viewModel.performWork()
        case .unknown:
            viewModel.checkCancellation()
        }
        buttonTag = tag
    }
}

struct view: View {
    var icon: String? = ""
    var title: String = ""
    var hidePadding: Bool? = false
    var tag: MainModelButtonTags? = .unknown
    
    init(icon: String? = nil, title: String, hidePadding: Bool? = nil) {
        self.icon = icon
        self.title = title
        self.hidePadding = hidePadding
    }
    
    var body: some View {
        switch tag {
        case .download, .send, .login, .register, .attach, .unknown:
            HStack {
                if hidePadding ?? false { Spacer() }
                Image(systemName: icon ?? "")
                if !icon.isEmptyOrNil { Divider() }
                Text(title)
                if hidePadding ?? false { Spacer() }
            }
        case .delete:
            Text(title)
        case .none:
            EmptyView()
        }
    }
}

#if DEBUG
struct MainContentView2_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel: MainModel = MainModel()
        MainContentView2(viewModel: viewModel)
    }
}
#endif
