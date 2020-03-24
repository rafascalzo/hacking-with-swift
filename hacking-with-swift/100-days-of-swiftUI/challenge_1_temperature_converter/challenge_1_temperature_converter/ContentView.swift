//
//  ContentView.swift
//  challenge_1_temperature_converter
//
//  Created by RVSM on 20/03/20.
//  Copyright © 2020 rvsm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    private let availableUnits:[UnitType] = [.temperature, .length, .time, .volume]
    
    private let unitTypes:[[UnitType]] = [
        [.celsius, .fahrenheit, .kelvin],
        [.meters, .kilometers, .feet, .yards, .miles],
        [.seconds, .minutes, .hours, .days],
        [.milliliters, .liters, .cups, .pints, .gallons]
    ]
   
    @State private var selectedUnitType = 0
    
    private var selectedTypes: [UnitType] {
        return unitTypes[selectedUnitType]
    }
    
    @State private var valueInput = ""
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    
    var temperatureConverted: String {
        guard let input = Double(valueInput) else { return "0"}
        guard inputUnit < selectedTypes.count else { return "0" }
        guard outputUnit < selectedTypes.count else { return "0" }
        let fromValue = Measurement(value: input, unit: unitType(unit: selectedTypes[inputUnit]))
        return "\(fromValue.converted(to: unitType(unit: selectedTypes[outputUnit])))"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Available Units")) {
                    Picker("Units", selection: $selectedUnitType) {
                        ForEach(0 ..< availableUnits.count) {
                            Text(self.availableUnits[$0].description())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text(availableUnits[selectedUnitType].description()), footer: Text("Result \(temperatureConverted)")) {
                    TextField("Input", text: $valueInput)
                        .keyboardType(.decimalPad)
                    
                    Section(header: Text("From")) {
                        Picker("input 1", selection: $inputUnit) {
                            ForEach( 0 ..< selectedTypes.count) {
                                Text(self.selectedTypes[$0].description())
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    .id(selectedUnitType)
                    }
                    Section(header: Text("To")) {
                        Picker("", selection: $outputUnit) {
                            ForEach (0 ..< selectedTypes.count) {
                                Text(self.selectedTypes[$0].description())
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    .id(selectedUnitType)
                    }
                }
                .navigationBarTitle("Unit converter")
            }
        }
    }
}

extension ContentView {
    
    enum UnitType {
        case temperature, length, time, volume
        
        case celsius, fahrenheit, kelvin
        case meters, kilometers, feet, yards, miles
        case seconds, minutes, hours, days
        case milliliters, liters, cups, pints, gallons
        
        func description() -> String {
            switch self {
            case .temperature: return "Temperature"
            case .length: return "Length"
            case .time: return "Time"
            case .volume: return "Volume"
            case .celsius: return "Celsius"
            case .fahrenheit: return "Fahrenheit"
            case .kelvin: return "Kelvin"
            case .meters: return "Meters"
            case .kilometers: return "Kilometers"
            case .feet: return "Feet"
            case .yards: return "Yards"
            case .miles: return "Miles"
            case .seconds: return "Seconds"
            case .minutes: return "Minutes"
            case .hours: return "Hours"
            case .days: return "Days"
            case .milliliters: return "Milliliters"
            case .liters: return "Liters"
            case .cups: return "Cups"
            case .pints: return "Pints"
            case .gallons: return "Gallons"
            }
        }
    }
    
    func unitType(unit: UnitType) -> Dimension {
        switch unit {
        case .celsius: return UnitTemperature.celsius
        case .fahrenheit: return UnitTemperature.fahrenheit
        case .kelvin: return UnitTemperature.kelvin
        case .meters: return UnitLength.meters
        case .kilometers: return UnitLength.kilometers
        case .feet: return UnitLength.feet
        case .yards: return UnitLength.yards
        case .miles: return UnitLength.miles
        case .seconds: return UnitDuration.seconds
        case .minutes: return UnitDuration.minutes
        case .hours: return UnitDuration.hours
        case .milliliters: return UnitVolume.milliliters
        case .liters: return UnitVolume.liters
        case .cups: return UnitVolume.cups
        case .pints: return UnitVolume.pints
        case .gallons: return UnitVolume.gallons
        default: return UnitLength.meters
        }
    }
    
    func days() -> NSCalendar.Unit {
        return NSCalendar.Unit.day
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
