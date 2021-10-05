//
//  ValidatedDecimal.swift
//  DistanceConverter
//
//  Created by Katharina Gopp on 05.10.21.
//

import Foundation

class ValidatedDecimal: ObservableObject {
    
    @Published var valueString = "" {
        didSet {
            var hasDecimalSeparator = false
            var filteredString = ""
            
            for char in valueString {
                if char.isNumber {
                    filteredString.append(char)
                } else if String(char) == Locale.current.decimalSeparator && !hasDecimalSeparator {
                    if filteredString.count == 0 {
                        filteredString = "0"
                    }
                    filteredString.append(char)
                    hasDecimalSeparator = true
                }
            }
            
            if valueString != filteredString {
                valueString = filteredString
            }
        }
    }
    
    var decimalValue: Double {
        let replacedString = valueString.replacingOccurrences(of: Locale.current.decimalSeparator!, with: ".")
        
        return Double(replacedString) ?? 0
    }
}
