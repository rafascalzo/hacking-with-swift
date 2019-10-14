//
//  ContentViewTest.swift
//  GuessTheFlag
//
//  Created by rafaeldelegate on 10/13/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

import SwiftUI

struct ContentViewTest: View {
    var body: some View {
        // GRADIENTS
        //LinearGradient(gradient: Gradient(colors: [.black, .blue, .pink, .purple]), startPoint: .top, endPoint: .bottom)
        //RadialGradient(gradient: Gradient(colors: [.black, .blue, .pink, .purple]), center: .center, startRadius: 20, endRadius: 200)
        //AngularGradient(gradient: Gradient(colors: [.black, .blue, .pink, .purple, .red, .orange, .green]), center: .center)
        
        Form{
            Section {
                VStack (spacing: 20.0) {
                    Text("Hello World")
                    Text("Another Hello World")
                }
            }
            Section {
                HStack (alignment: .center, spacing: 20){
                    Text("Hello World")
                    Text("Another Hello World")
                }
            }
            Section {
                ZStack (alignment: .top){
                    //Text("Hello World")
                    Text("This is inside a stack")
                    // .background(Color.red)
                }
                //.background(Color.red)
            }
            Section {
                
                ZStack {
                    //Color.red.frame(width: 200, height: 200)
                    //Color(red: 1, green: 0.8, blue: 0)
                    Color(red: 1, green: 0.8, blue: 0).edgesIgnoringSafeArea(.all)
                    Text("This is inside a stack")
                    // .background(Color.red)
                }
                //.background(Color.red)
            }
        }
    }
}

struct ContentViewTest_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewTest()
    }
}

//IMAGES AND BUTTONS
//struct ContentView: View {

//    var body: some View {
//        Button(action: {
//        }) {
//            HStack(alignment: .center, spacing: 10) {
//                Image(systemName: "pencil")
//                    //Tip: If you find that your images have become filled in with a color, for example showing as solid blue rather than your actual picture, this is probably SwiftUI coloring them to show that they are tappable. To fix the problem, use the renderingMode(.original) modifier to force SwiftUI to show the original image rather than the recolored version.
//                    .renderingMode(.original)
//                Text("Edit")
//            }
//        }
//    }
//}

//ALERTS

//struct ContentView: View {
//    @State private var showingAlert = false
//    var body: some View {
//        Button("Show Alert") {
//            self.showingAlert = true
//        }
//        .alert(isPresented: $showingAlert) { () -> Alert in
//            Alert(title: Text("Hello SwiftUI"), message: Text("Detail message"), dismissButton:
//                .default(Text("OK")))
//        }
//        
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
