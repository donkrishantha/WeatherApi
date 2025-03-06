//
//  DetailContentView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import SwiftUI

struct DetailContentView: View {
    
    @ObservedObject private var viewModel: DetailViewModel
    
    /// ------------Timer -----
    @State var countDownTimer = 10
    @State var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(viewModel: DetailViewModel) {
#if os(iOS)
  print("print on iOS only")
#elseif os(macOS)
  print("print on macOS only")
#elseif os(watchOS)
  print("print on watchOS only")
#endif
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topLeading){
                VStack(alignment: .leading) {
                    Text("BASE_URL: \(Environment.baseUrl)")
                    Text("\(Environment.apiKy)")
                }
                Spacer()
                VStack {
                    Text("\(countDownTimer)")
                        .onReceive(timer) { _ in
                            if countDownTimer > 0 && timerRunning {
                                countDownTimer -= 1
                                //viewModel.updateCounter()
                                print(countDownTimer)
                                viewModel.testObserverDesignPattern(count: countDownTimer)
                            } else {
                                timerRunning = false
                            }
                        }
                        .font(.system(size: 80, weight: .bold))
                        .opacity(1)
                    
                    HStack(spacing: 30) {
                        Button("Start") {
                            timerRunning = true
                        }
                        
                        Button("Reset") {
                            countDownTimer = 10
                        }.foregroundColor(.red)
                    }
                }
            }
            
            .navigationTitle("Environment Details")
        }
    }
}

#if DEBUG
struct DetailContentView_Preview: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        let repository: any WeatherApiRepoProtocol = dependencyContainer.weatherApiRepository
        let viewModel: DetailViewModel = DetailViewModel(repository: repository as! WeatherApiRepoImplement)
        DetailContentView(viewModel: viewModel)
    }
}
#endif
