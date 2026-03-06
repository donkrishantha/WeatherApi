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
    case cancel
    case login
    case register
    case attach
    case unknown
}

final class MainModel: ObservableObject {
    
    @Published var loadingTask: Task<Void, Never>?
    @Published var isLoading: Bool = false
    //var isLoading2: Bool { loadingTask != nil }
    
    init() {
        testGroupingDictionary3()
    }
    
    func performWork() {
        guard loadingTask == nil else {
            return
        }
        
        checkCancellation()
        if Task.isCancelled { return }
        loadingTask = Task(priority: .background) {
            //try? await request()
            
            do {
                _ = try await request()
            } catch where error is CancellationError {
                cleanUp()
            } catch {
                print("Task was cancelled")
                print(error.localizedDescription)
            }

            await MainActor.run {
                isLoading = false
                loadingTask = nil
            }
        }
    }
    
    private func request() async throws -> String {
        await MainActor.run {
            isLoading = true
        }
        //try? await Task.sleep(nanoseconds: 5_000_000_000)
        for i in 1...5 {
            print("loop: \(i), isLoading: \(isLoading)")
            //if Task.isCancelled { return }
            //try Task.checkCancellation() // its realy importent
            sleep(1)
            //try? Task.checkCancellation()
            await Task.yield()
        }
        print("Finished task")
        
        return "Gayan...!"
    }
    
    private func cleanUp() {
        print("Clean up ui!")
    }
    
    func checkCancellation() {
        print("Task cancelled")
        loadingTask?.cancel()
        loadingTask = nil
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
            
            Button {
                action(.delete)
            } label: {
                label(.delete)
            }
            //.buttonStyle(GeneralButtonStyle(tag: $buttonTag, bgColor: .red))
            .buttonStyle(GeneralButtonStyle(tag: $buttonTag, bgColor: .red))
            .environment(\.appButtonTags, .delete)

            
            Button {
                action(.delete)
            } label: {
                label(.delete)
            }
            .buttonStyle(GeneralButtonStyle(tag: $buttonTag, bgColor: .red))
            .environment(\.appButtonTags, .delete)
            
            //------------------------
            Button {
                action(.download)}
            label: {
                label(.download)
            }.buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .orange))
            .environment(\.appButtonTags, .download)
            
            //-----------------------
            Button {
                action(.login)
            }
            label: {
                label(.login)
            }.buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .green))
            .environment(\.appButtonTags, .login)
            
            //-----------------------
            Button {
                action(.register)
            } label: {
                label(.register)
            }.buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .blue))
            .environment(\.appButtonTags, .register)
            
            //-----------------------
            Button {
                action(.attach)
            }
            label: {
                label(.attach)
            }.buttonStyle(LoadingButtonStyle(tag: $buttonTag,
                                            isLoading: $viewModel.isLoading,
                                            bgColor: .blue))
            .environment(\.appButtonTags, .attach)
            
            //-----------------------
            
            Button {
                action(.cancel)
            } label: {
                label(.cancel)
            }.buttonStyle(GeneralButtonStyle(tag: $buttonTag, bgColor: .purple))
            .environment(\.appButtonTags, .cancel)
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
        case .cancel:
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
            viewModel.testGroupingDictionary3()
        case .download:
            viewModel.performWork()
        case .cancel:
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
        case .download, .cancel, .login, .register, .attach, .unknown:
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

extension MainModel {
    private func testSortingJson() {
        struct Patients: Codable {
            var id: String
            var severity: Int
            var arrivalTime: Int
        }
        
        let arrays = [
            Patients(id: "p1", severity: 3, arrivalTime: 10),
            Patients(id: "p2", severity: 5, arrivalTime: 15),
            Patients(id: "p3", severity: 5, arrivalTime: 5),
            Patients(id: "p4", severity: 2, arrivalTime: 20)
        ]
        
        // Expected : p2, p3, p1 ,p4
        
        //let groupBy: [Int : [Patients]] = Dictionary(grouping: arrays, by: { $0.arrivalTime })
        //let filter: [Patients] = arrays.filter{ $0.severity >= 5  }
        let sorted: [Patients] = arrays.sorted(by: { ($0.severity > $1.severity) })
        let sortedAndMapValue: [String] = arrays.sorted(by: { ($0.severity > $1.severity) }).map({ $0.id })
        let mapValue: [String] = sorted.map({ $0.id })
        print(mapValue)
        

        let jsonData = """
        [
            {    
                "id": "p1",
                "severity": 3,
                "arrivalTime": 10,
            },
            {    
                "id": "p2",
                "severity": 5,
                "arrivalTime": 15,
            },
            {    
                "id": "p3",
                "severity": 5,
                "arrivalTime": 5,
            },
            {    
                "id": "p4",
                "severity": 2,
                "arrivalTime": 20,
            }
        ]
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let userArray: [Patients] = try decoder.decode([Patients].self, from: jsonData)
            let sortedArray:  [Patients] = userArray.sorted(by: { ($0.severity > $1.severity) })
            let mappedId: [String] = sortedArray.map({ $0.id })
            print(mappedId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func testGroupingDictionary() {
        struct Person {
            let name: String
            let age: Int
        }

        let people = [
            Person(name: "Alice", age: 30),
            Person(name: "Bob", age: 25),
            Person(name: "Charlie", age: 30),
            Person(name: "David", age: 25),
            Person(name: "Eve", age: 35),
            Person(name: "Frank", age: 35),
            Person(name: "Grace", age: 25),
            Person(name: "Harry", age: 30),
            Person(name: "Iris", age: 35),
            Person(name: "Jack", age: 25),
        ]

        let groupedPeople = Dictionary(grouping: people, by: { $0.age })
        print(groupedPeople)
    }
    
    private func testGroupingDictionary2() {
        struct Transaction {
            let date: Date
            let amount: Double
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let transactions = [
            Transaction(date: dateFormatter.date(from: "2022-01-01")!, amount: 100.0),
            Transaction(date: dateFormatter.date(from: "2022-01-02")!, amount: 200.0),
            Transaction(date: dateFormatter.date(from: "2022-01-02")!, amount: 150.0),
            Transaction(date: dateFormatter.date(from: "2022-01-03")!, amount: 50.0),
            Transaction(date: dateFormatter.date(from: "2022-01-03")!, amount: 75.0),
            Transaction(date: dateFormatter.date(from: "2022-01-03")!, amount: 125.0),
        ]

        let groupedTransactions = Dictionary(grouping: transactions, by: { dateFormatter.string(from: $0.date) })
        print(groupedTransactions)
    }
    
    func testGroupingDictionary3() {
        struct Product {
            let name: String
            let price: Double
            let category: productType
        }
        
        enum productType {
            case electronics
            case Clothing
            case accessories
        }

        let products = [
            Product(name: "iPhone", price: 999.0, category: .electronics),
            Product(name: "MacBook Pro", price: 1999.0, category: .electronics),
            Product(name: "Shirt", price: 20, category: .Clothing),
            Product(name: "T-Shirt", price: 20, category: .Clothing),
            Product(name: "Jeans", price: 50, category: .Clothing),
            Product(name: "Backpack", price: 89.99, category: .accessories),
            Product(name: "Watch", price: 299.99, category: .accessories),
        ]
        
        // Get the sum of "price"
        let filter = products.filter{ $0.category == .Clothing }
        let price: [Double] = filter.map { $0.price }
        let reduce: Double = price.reduce(0, +)
        print(reduce)
    }
    
    private func testGroupingDictionary4() {
        struct Person {
            var name: String
            var city: String
        }
        
        let _: [Person] = [
            .init(name: "Johanna", city: "Stockholm"),
            .init(name: "Daniel", city: "Stockholm"),
            .init(name: "Joe", city: "Washington"),
            .init(name: "Kamala", city: "San Francisco")
        ]
        
//        extension Collection where Element == Person {
//            func groupedByCity() -> Dictionary<String, [Element]> {
//                Dictionary(grouping: self, by: { $0.city })
//            }
//        }
        
//        persons.groupedByCity()
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
