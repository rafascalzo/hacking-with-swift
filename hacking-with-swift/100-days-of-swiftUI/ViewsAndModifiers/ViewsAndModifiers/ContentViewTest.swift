//
//  ContentViewTest.swift
//  ViewsAndModifiers
//
//  Created by rafaeldelegate on 10/16/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

//Text("Hello World")
//.frame(maxWidth: .infinity, maxHeight: .infinity)
//.background(Color.red)
//.edgesIgnoringSafeArea(.all)

//import Foundation
//struct ContentView: View {
//    var body: some View {
////        Button("Hello World") {
////            print(type(of: self.body))
////        }
////        .background(Color.red)
////        .frame(width: 200, height: 200)
////        Button("Hello World") {
////            print(type(of: self.body))
////        }
////        .frame(width: 200, height: 200)
////        .background(Color.red)
//        
//        Text("Hello Word")
//        .padding()
//            .background(Color.red)
//        .padding()
//            .background(Color.blue)
//        .padding()
//            .background(Color.green)
//        .padding()
//            .background(Color.purple)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


//        Button("Hello World") {
//            self.useRedText.toggle()
//        }
//        .foregroundColor(useRedText ? .red : .blue)

//environment modifiers

//struct ContentView: View {
//    @State private var useRedText = false
//    var body: some View {
//        VStack {
//            Text("Gryffindor")
//                .font(.largeTitle)
//                .blur(radius: 0)
//            Text("Huffflepuff")
//            Text("Ravenclaw")
//            Text("Slytherin")
//        }
//        .font(.title)
//    .blur(radius: 5)
//    }
//}


// views as properties
//struct ContentView: View {
//    
//    var motto1: some View { Text("Draco dormiens") }
//    let motto2 = Text("nunquam titillandus")
//    var body: some View {
//        VStack {
//            motto1
//                .foregroundColor(Color.red)
//            motto2
//                .foregroundColor(Color.blue)
//        }
//    }
//}


//view composition
//struct CapsuleText: View {
//    var text: String
//    var body: some View {
//        Text(text)
//        .font(.largeTitle)
//        .padding()
//        //.foregroundColor(.white)
//        .background(Color.blue)
//        .clipShape(Capsule())
//    }
//}
//
//struct ContentView: View {
//    
//    var motto1: some View { Text("Draco dormiens") }
//    let motto2 = Text("nunquam titillandus")
//    var body: some View {
//      VStack(spacing: 10) {
//            CapsuleText(text: "first")
//                .foregroundColor(Color.white)
//        CapsuleText(text: "second")
//            .foregroundColor(Color.purple)
//        }
//    }
//}


// custom modifiers

//struct Title: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.largeTitle)
//            .foregroundColor(Color.purple)
//        .padding()
//            .background(Color.yellow)
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//    }
//}
//
//extension View {
//    func titleStyle() -> some View {
//        self.modifier(Title())
//    }
//}
//
//struct Watermark: ViewModifier {
//    var text: String
//
//    func body(content: Content) -> some View {
//        ZStack(alignment: .bottomTrailing) {
//            content
//            Text(text)
//                .font(.caption)
//                .foregroundColor(.white)
//                .padding(5)
//                .background(Color.black)
//        }
//    }
//}
//
//extension View {
//    func watermarked(with text: String) -> some View {
//        self.modifier(Watermark(text: text))
//    }
//}
//
//
//struct ContentView: View {
//    
//    var body: some View {
////        Text("dasdsa")
////        .titleStyle()
//        Color.blue
//        .frame(width: 300, height: 300)
//        .watermarked(with: "rafael sta com sono")
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
