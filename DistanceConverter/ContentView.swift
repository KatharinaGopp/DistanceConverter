//
//  ContentView.swift
//  DistanceConverter
//
//  Created by Katharina Gopp on 05.10.21.
//

import SwiftUI

struct ContentView: View {
    @State var startDistanceUnit: DistanceUnit = .kilometer
    @State var endDistanceUnit: DistanceUnit = .mile
//    @State var startValueString = ""
    @ObservedObject var startValue = ValidatedDecimal()
    
    @State var conversionHistory: [Conversion] = []
    
    var body: some View {
        VStack {
            // Headline
            Text("Distance Conversion")
                .font(.title)
                .bold()
                .padding()
            
            // Conversion Input
            HStack {
                Text("Distance:")
                TextField("e.g. 5\(Locale.current.decimalSeparator!)3", text: $startValue.valueString)
                    .keyboardType(.decimalPad)
                Picker("\(startDistanceUnit.rawValue)", selection: $startDistanceUnit) {
                    ForEach(DistanceUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal, 25)
            
            HStack {
                Spacer()
                
                Text("Convert to: ")
                Picker("\(endDistanceUnit.rawValue)", selection: $endDistanceUnit) {
                    ForEach(DistanceUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
            }
            
            // Convert Button
            HStack {
                Spacer()
                
                Button(action: {
                    saveConversion()
                    resetInput()
                }) {
                    Text("Convert")
                }
                .disabled(startValue.valueString == "")
                .padding()
                .background(startValue.valueString == "" ? Color.gray : Color.green)
                .foregroundColor(startValue.valueString == "" ? .black.opacity(0.2) : .black)
                .cornerRadius(15)
                
                Spacer()
            }
            
            // Conversion History
            List {
                ForEach(conversionHistory.reversed()) { currentConversion in
                    HStack {
                        Spacer()
                        
                        Text(printConversion(conversion:currentConversion))
                        
                        Spacer()
                    }
                }
            }
            .background(Color.white)
        }
    }
    
    // Functions
    func convertUnit(valueToConvert: Double, fromUnit: DistanceUnit, toUnit: DistanceUnit) -> Double {
        return valueToConvert * fromUnit.conversionFactorToMeter / toUnit.conversionFactorToMeter
    }
    
    func saveConversion() {
        var conversion = Conversion()
        
        conversion.startDistanceUnit = startDistanceUnit
        conversion.endDistanceUnit = endDistanceUnit
        conversion.startValue = startValue.decimalValue
        conversion.endValue = convertUnit(valueToConvert: conversion.startValue, fromUnit: startDistanceUnit, toUnit: endDistanceUnit)
        
        conversionHistory.append(conversion)
    }
    
    func resetInput() {
        startValue.valueString = ""
    }
    
    func printConversion(conversion: Conversion) -> String {
        return printDistanceWithUnit(distance: conversion.startValue, unit: conversion.startDistanceUnit) + " -> " + printDistanceWithUnit(distance: conversion.endValue, unit: conversion.endDistanceUnit)
    }
    
    func printDistanceWithUnit(distance: Double, unit: DistanceUnit) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6 // Change this value for accuracy
        
        var returnString = ""
        
        let value = NSNumber(value: distance)
        if let distanceString = formatter.string(from: value) {
            returnString = distanceString + " " + unit.rawValue
        }
        
        return returnString
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
