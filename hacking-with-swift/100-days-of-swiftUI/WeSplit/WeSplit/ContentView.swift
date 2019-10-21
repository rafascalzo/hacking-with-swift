//
//  ContentView.swift
//  WeSplit
//
//  Created by rafaelviewcontroller on 10/9/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    @State private var noAmount = true
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(Int(numberOfPeople) ?? 1)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    var totalAmountForCheck: Double {
        let peopleCount = Double((Int(numberOfPeople) ?? 0) + 2)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        return grandTotal
    }
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Amount ", text: $checkAmount)
                        //.keyboardType(.decimalPad)
                        .keyboardType(.numberPad)
                        
                    
//                    Picker("Number of People", selection: $numberOfPeople) {
//                        ForEach (2..<100) {
//                            TextField("People z\($0)", text: self.$checkAmount)
//                            Text("\($0) people")
//                        }
//                        .keyboardType(.alphabet)
//                    }
                    TextField("NumberOfPeople", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("How much tip do you want to leave?")){
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach (0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                Section(header: Text("Total amount for the check")) {
                    Text("$\(totalAmountForCheck, specifier: "%.2f")")
                        .foregroundColor(totalAmountForCheck == 0 ? Color.red : Color.blue)
                }
                
            }
        .navigationBarTitle("WeSplit")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
