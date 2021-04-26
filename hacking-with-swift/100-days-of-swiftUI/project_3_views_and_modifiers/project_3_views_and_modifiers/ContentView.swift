//
//  ContentView.swift
//  project_3_views_and_modifiers
//
//  Created by RVSM on 25/03/20.
//  Copyright © 2020 rvsm. All rights reserved.
//

/*
 Text("Hello, World!")
 .frame(maxWidth: .infinity, maxHeight: .infinity)
 .background(Color.yellow)
 .edgesIgnoringSafeArea(.all)
 
 the order of our modifiers matter
 
 Button("Hello World") {
 print(type(of: self.body))
 }
 .background(Color.red)
 .frame(width: 200, height: 200)
 
 is different than
 
 Button("Hello World") {
 print(type(of: self.body))
 }
 .frame(width: 200, height: 200)
 .background(Color.red)
 
 var body: some View {
 
 Text("Hello World")
 .padding()
 .background(Color.red)
 .padding()
 .background(Color.blue)
 .padding()
 .background(Color.green)
 .padding()
 .background(Color.yellow)
 
 }
 
 var body: Text {
 Text("Hello World")
 }
 // this body swiftUI allows because swiftui requires an typealias of some view, no matter what it its since implemente view protocol, swift ui wants to know what type is
 
 for VStacks swift stores on a tupple array, this is why can have no more than 10 elements
 
 conditional modifiers
 @State private var useRedText = true
 
 var body: some View {
 Button("Change me") {
 self.useRedText.toggle()
 }
 .foregroundColor(useRedText ? Color.red: .blue)
 }
 
 // environment modifiers can modify containers with same modifiers. it is different than regular modifiers (.blur)  blur() is a regular modifier, so any blurs applied to child views are added to the VStack blur rather than replacing it. we need to test to know about them
 VStack {
 Text("Gryffindor")
 .font(.largeTitle)
 .blur(radius: 0)
 Text("Hufflepuff")
 Text("Ravenclaw")
 Text("Slytherin")
 }
 .font(.title)
 .blur(radius: 5)
 
 views as properties and computed properties
 
 let motto1 = Text("Draco dormiens")
 let motto2 = Text("nunquam titillandus")
 
 var motto3: some View { Text("Draco dormiens") }
 
 var body: some View {
 VStack {
 motto1
 .foregroundColor(Color.red)
 motto2
 .foregroundColor(Color.blue)
 }
 }
 */

import SwiftUI
/* View composion
 struct CapsuleText: View {
 var text: String
 
 var body: some View {
 Text(text)
 .font(.largeTitle)
 .padding()
 .foregroundColor(.white)
 .background(Color.blue)
 .clipShape(Capsule())
 }
 }
 struct ContentView: View {
 
 
 var body: some View {
 VStack(spacing: 10) {
 CapsuleText(text: "First")
 CapsuleText(text: "Second")
 }
 }
 
 }
 
 same then
 
 struct ContentView: View {
 var body: some View {
 VStack(spacing: 10) {
 Text("First")
 .font(.largeTitle)
 .padding()
 .foregroundColor(.white)
 .background(Color.blue)
 .clipShape(Capsule())
 
 Text("Second")
 .font(.largeTitle)
 .padding()
 .foregroundColor(.white)
 .background(Color.blue)
 .clipShape(Capsule())
 }
 }
 }
 */

/*
 struct Title: ViewModifier {
 func body(content: Content) -> some View {
 content
 .font(.largeTitle)
 .foregroundColor(.white)
 .padding()
 .background(Color.blue)
 .clipShape(RoundedRectangle(cornerRadius: 10))
 }
 }
 
 //When working with custom modifiers, it’s usually a smart idea to create extensions on View that make them easier to use. For example, we might wrap the Title modifier in an extension such as this:
 
 extension View {
 func titleStyle() -> some View {
 self.modifier(Title())
 }
 }
 
 // Custom modifiers can do much more than just apply other existing modifiers – they can also create new view structure, as needed. Remember, modifiers return new objects rather than modifying existing ones, so we could create one that embeds the view in a stack and adds another view:
 
 struct Watermark: ViewModifier {
 var text: String
 
 func body(content: Content) -> some View {
 ZStack(alignment: .bottomTrailing) {
 content
 Text(text)
 .font(.caption)
 .foregroundColor(.white)
 .padding(5)
 .background(Color.black)
 }
 }
 }
 
 extension View {
 func watermarked(with text: String) -> some View {
 self.modifier(Watermark(text: text))
 }
 }
 
 struct ContentView: View {
 var body: some View {
 //      Text("Hello World")
 //        //.modifier(Title())
 //        .titleStyle()
 
 Color.blue
 .frame(width: 200, height: 200)
 .watermarked(with: "Rafael Scalzo")
 }
 
 }
 */

// Custom Containers

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    // For more flexibility we could leverage one of SwiftUI’s features called view builders, which allows us to send in several views and have it form an implicit stack for us.
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach ( 0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

struct ProeminentTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
        //.fontWeight(.bold)
        .font(.largeTitle)
        .foregroundColor(.blue)
    }
}

extension View {
    
    func proeminentTitle() -> some View {
        self.modifier(ProeminentTitle())
    }
}

struct ContentView: View {
    var body: some View {
        //        GridStack(rows: 4, columns: 4) { row, col in
        //            HStack {
        //                Image(systemName: "\(row * 4 + col).circle")
        //                Text("R\(row) C\(col)")
        //            }
        //
        //        }
        
        //        GridStack(rows: 4, columns: 4) { row, col in
        //            Image(systemName: "\(row * 4 + col).circle")
        //            Text("R\(row) C\(col)")
        //        }
        VStack(spacing: 30) {
            Text("heyyy")
                .proeminentTitle()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
