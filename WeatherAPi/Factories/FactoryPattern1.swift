//
//  FactoryPattern1.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 14/12/2024.
//

import Foundation

protocol Report {
    func generate() -> String
}

class PDFReport: Report {
    func generate() -> String {
        return "Generating PDF Report"
    }
}
class ExcelReport: Report {
    func generate() -> String {
        return "Generating Excel Report"
    }
}
class ReportFactory {
    static func createReport(type: String) -> Report? {
        if type == "pdf" {
            return PDFReport()
        } else if type == "excel" {
            return ExcelReport()
        }
        return nil
    }
}

// Client Code
class ReportManager {
    
    func testFactoryPattern() {
        
        //Usage with Factory Pattern
        if let report = ReportFactory.createReport(type: "pdf") {
            print(report.generate())  // Output: Generating PDF Report
        }
    }
}
