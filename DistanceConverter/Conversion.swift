//
//  Converseion.swift
//  DistanceConverter
//
//  Created by Katharina Gopp on 05.10.21.
//

import Foundation

struct Conversion: Identifiable {
    var id: UUID = UUID()
    
    var startValue: Double = 0.0
    var startDistanceUnit: DistanceUnit = .kilometer
    var endValue: Double = 0.0
    var endDistanceUnit: DistanceUnit = .mile
}
