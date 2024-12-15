//
//  PropertyWrappers.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 15/12/2024.
//

import Foundation


struct ConsoleLogged<Value> {
    private var value: Value
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            print("New value is \(newValue)")
        }
    }
}

//----------------------------------------

@propertyWrapper
struct Capitalized {
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
    
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.capitalized
        }
    }
}

//-------------------------------------

@propertyWrapper
struct Price {
    private var price: Double
    
    //    init() {
    //        self.price = 0.0
    //    }
    
    init(wrappedValue: Double) {
        self.price = wrappedValue
    }
    
    var wrappedValue: Double {
        get {
            return self.price
        }
        set {
            if newValue < 0.0 {
                self.price = 0.0
            } else if newValue > 10_000 {
                return
            } else {
                self.price = newValue
            }
        }
    }
}

struct Article {
    var vendor: String
    var name: String
    @Price var price: Double
}

class TestWrapper {
    
    func testPropertrappers() {
        var display = Article(vendor: "Asus", name: "X127", price: 139.0)
        /*
         expression failed to parse:
         error: Playground.playground:33:60: error: cannot convert value of type 'Double' to expected argument type 'Price'
         var display = Article(vendor: "Asus", name: "X127", price: 139.0)
         */
        print("\(display.vendor) Display costs \(display.price) Euro")
    }
}

///---------------------------------------------------------

@propertyWrapper
struct AllCaps {
    private var name: String
    var wrappedValue: String {
        set {
            name = newValue
        }
        get {
            return name.uppercased()
        }
    }
    init(wrappedValue: String) {
        self.name = wrappedValue
    }
}
// usage
struct Student {
    @AllCaps var firstName: String
    @AllCaps var lastName: String
}

//var student = Student(firstName: "Steve", lastName: "Jobs")
//print("Hello \(student.firstName) \(student.lastName)")
// output:
//Hello STEVE JOBS

//----------------------------------------------------------
@propertyWrapper struct InRange {
    private var mark: Int
    var wrappedValue: Int {
        set {
            mark = newValue
        }
        get {
            return max(0, min(mark, 100))
        }
    }
    init(wrappedValue: Int) {
        mark = wrappedValue
    }
}

struct Student1 {
    @InRange var mark: Int
}

//let student1 = Student1(mark: 75)
//print(student1.mark)
//// output:
//75
//let student2 = Student1(mark: 110)
//print(student2.mark)
//// output:
//100
//let student3 = Student1(mark: -20)
//print(student3.mark)
//// output:
//0
//----------------------------------------------------------

//----------------------------------------------------------

//----------------------------------------------------------
