//
//  ContentView.swift
//  UnitConversor
//
//  Created by rafaeldelegate on 10/13/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Constants
    let temperatureUnits = ["Celsius","Kelvin","Fahrenheit"]
    
    //MARK: - Variables
    @State private var temperatureInputSelected = 0
    @State private var temperatureOutputSelected = 0
    @State private var temperatureInput = ""
    
    var temperature: Double {
        switch temperatureInputSelected {
        case 0:
            switch temperatureOutputSelected {
            case 0: return Double(temperatureInput) ?? 0
            case 1: return (Double(temperatureInput) ?? 0) + 273.15
            case 2: return 9/5 * (Double(temperatureInput) ?? 0) + 32
            default: return 0
            }
        case 1:
            switch temperatureOutputSelected {
            case 0: return (Double(temperatureInput) ?? 0) - 273.15
            case 1: return Double(temperatureInput) ?? 0
            case 2:
                guard let kelvin = Double(temperatureInput) else { return 0 }
                return 9/5 * (kelvin - 273.15) + 32
            default: return 0
            }
        case 2:
            switch temperatureOutputSelected {
            case 0: return 5/9 * (Double(temperatureInput) ?? 0) - 32
            case 1:
                guard let fahrenheit = Double(temperatureInput) else { return 0}
                return (5/9 * (fahrenheit - 32)) + 273.15
            case 2: return Double(temperatureInput) ?? 0
            default: return 0
            }
        default: return Double(temperatureInput) ?? 0.0
        }
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Temperature Conversion")) {
                    TextField("Temperature: ", text: $temperatureInput)
                    Text("Choose input format")
                    Picker("Temperature Input", selection: $temperatureInputSelected) {
                        ForEach (0..<temperatureUnits.count) {
                            Text("\(self.temperatureUnits[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Text("Choose output format")
                    Picker("Temperature Input", selection: $temperatureOutputSelected) {
                        ForEach (0..<temperatureUnits.count) {
                            Text("\(self.temperatureUnits[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Text("Conversion: \(temperature, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("Unit Conversor")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
