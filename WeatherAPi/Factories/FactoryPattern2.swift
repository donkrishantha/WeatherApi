//
//  FactoryPattern2.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 14/12/2024.
//

import Foundation
import UIKit

enum FoodType {
    case pepperoni
    case cheese
    case hawaiian
}

enum Restaurant {
    case dominos
    case pizzahut
    case littlecaesars
}

protocol FoodFactory {
    func createFood(type: FoodType, restaurant: Restaurant) -> Food
}

class PizzaFactory: FoodFactory {
    func createFood(type: FoodType, restaurant: Restaurant) -> Food {
        switch type {
        case .pepperoni:
            return PepperoniPizza(restaurant: restaurant)
        case .cheese:
            return CheesePizza(restaurant: restaurant)
        case .hawaiian:
            return HawaiianPizza(restaurant: restaurant)
        }
    }
}

class Food {
    private let restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    func getRestaurant() -> Restaurant {
        return restaurant
    }
}

class PepperoniPizza: Food {
    override init(restaurant: Restaurant) {
        super.init(restaurant: restaurant)
    }
}

class CheesePizza: Food {
    override init(restaurant: Restaurant) {
        super.init(restaurant: restaurant)
    }
}

class HawaiianPizza: Food {
    override init(restaurant: Restaurant) {
        super.init(restaurant: restaurant)
    }
}

// Example usage:
class CheckFactory {
    
    func testFacto() {
        let pizzaFactory = PizzaFactory()
        let pepperoniPizza = pizzaFactory.createFood(type: .pepperoni, restaurant: .dominos)
        print(pepperoniPizza.getRestaurant()) // Dominos
    }
}

//---------------------Method 2----------------------

protocol ProductFactory {
    func createProduct(data: ProductData) -> Product
}

class BookFactory: ProductFactory {
    func createProduct(data: ProductData) -> Product {
        return Book(data: data)
    }
}

class ElectronicsFactory: ProductFactory {
    func createProduct(data: ProductData) -> Product {
        return Electronics(data: data)
    }
}

class ClothingFactory: ProductFactory {
    func createProduct(data: ProductData) -> Product {
        return Clothing(data: data)
    }
}

enum ProductType {
    case book
    case electronics
    case clothing
}

struct ProductData {
    let name: String
    let price: Double
    let image: UIImage?
}

class Product {
    let type: ProductType
    let name: String
    let price: Double
    let image: UIImage?

    init(type: ProductType, name: String, price: Double, image: UIImage? = nil) {
        self.type = type
        self.name = name
        self.price = price
        self.image = image
    }
}

class Book: Product {
    init(data: ProductData) {
        super.init(type: .book, name: data.name, price: data.price, image: data.image)
    }
}

class Electronics: Product {
    init(data: ProductData) {
        super.init(type: .electronics, name: data.name, price: data.price, image: data.image)
    }
}

class Clothing: Product {
    init(data: ProductData) {
        super.init(type: .clothing, name: data.name, price: data.price, image: data.image)
    }
}

// Usage:
class CheckFactoryPattern {
    
    func testFAC() {
        let bookData = ProductData(name: "New", price: 3.5, image: UIImage(named: "dhhged"))
        let productFactory = BookFactory()
        let book = productFactory.createProduct(data: bookData)
        print(book.name)
    }
}

// Display the book to the user or add it to the user's shopping cart.
