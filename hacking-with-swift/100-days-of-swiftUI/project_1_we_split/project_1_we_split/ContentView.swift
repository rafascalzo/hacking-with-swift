//
//  ContentView.swift
//  project_1_we_split
//
//  Created by RVSM on 17/03/20.
//  Copyright © 2020 rvsm. All rights reserved.
//

import SwiftUI

/*
 .navigationBarTitle(Text("We Split"))
 
 let students = ["Harry", "Hermione", "Ron"]
  @State private var selectedStudent = 0
 
 var body: some View {
     VStack {
         Picker("Select your student", selection: $selectedStudent) {
             ForEach(0 ..< students.count) {
                 Text(self.students[$0])
             }
         }
         Text("You choose \(students[selectedStudent])")
     }
 }
 
 Picker("Number of people", selection: $numberOfPeople) {
                        ForEach (2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
 
 */

struct ContentView: View {
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = "2"
    @State private var tipPercentage = 2
    
    var nothing: Bool {
        return self.tipPercentages[self.tipPercentage] == 0
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(Int(numberOfPeople) ?? 0)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        return grandTotal / peopleCount
    }
    
    var totalAmountForCheck: Double {
        let orderAmount = Double(checkAmount) ?? 0
        let tipSelection = Double(tipPercentages[tipPercentage])
        
        let tipValue = orderAmount / 100 * tipSelection
        return orderAmount + tipValue
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    TextField("Number of people", text: $numberOfPeople)
                        .keyboardType(.decimalPad)
                }
                Section(header:Text("Houw much tip you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Amount per person")) {
                    Text("\(totalPerPerson, specifier: "%.2f")")
                }
                Section(header: Text("Total amount for the check")) {
                    Text("\(totalAmountForCheck, specifier: "%.2f")")
                        .foregroundColor( nothing ? .red : .black)
                }
            }
        .navigationBarTitle("We Split")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
