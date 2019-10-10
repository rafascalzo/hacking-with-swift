//
//  ContentViewTest.swift
//  WeSplit
//
//  Created by rafaelviewcontroller on 10/9/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.



import SwiftUI

struct ContentViewTest: View {
    @State var name = ""
    @State var tapCount = 0
    @State var students = ["Rafael", "Samantha", "Harry", "Janaina","Carol","Thamyris"]
    @State private var selectedStudent = "Harry"
    
    var body: some View {
        
        //        Picker("Select your  student", selection: $selectedStudent) {
        //                               ForEach (0..<students.count) {
        //                                   Text(self.students[$0])
        //                               }
        //                           }
        
        
        NavigationView {
            Form {
                Section {
                    Text("Hello World")
                    Button("Tap Count \(self.tapCount)"){
                        self.tapCount += 1
                    }
                }
                Section {
                    TextField("Enter your name", text: $name)
                    Text("Your name is " + name)
                }
                Section {
                    ForEach(0..<10) {
                        Text("Row \($0)")
                    }
                }
                Section {
                    
                    ForEach(0..<students.count){
                        Text("\(self.students[$0])")
                    }
                }
                Section {
                    Picker("Select your  student", selection: $selectedStudent) {
                        ForEach (0..<students.count) {
                            Text(self.students[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("SwiftUI"), displayMode: .inline)
        }
    }
}

struct ContentViewTest_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
