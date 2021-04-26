//
//  ContentView.swift
//  project_2_guess_the_flag
//
//  Created by FulltrackMobile on 22/03/20.
//  Copyright © 2020 rvsm. All rights reserved.
//
/*
 Vertical stacks
 
 VStack(alignment: .leading, spacing: 10) {
 Text("Hello, World!")
 Text("Another hello world")
 }
 
 Horizontal stacks
 
 HStack(alignment: .center, spacing: 10) {
 Text("Hello, World!")
 Text("Another hello world")
 }
 
 Spacer
 
 VStack {
 Text("First")
 Spacer()
 Text("Second")
 Spacer()
 Text("Third")
 Spacer()
 }
 
 Zstacks (depth)
 
 ZStack(alignment: .top) {
 Text("Hello")
 Text("Hello inside")
 }
 
 Colors
 
 ZStack(alignment: .top) {
 Color.red.frame(width: 200, height: 200)
 Text("Hello world!")
 //.background(Color.yellow)
 }
 .background(Color.yellow)
 
 Theese two options have no difference, to full paint a stack need to set color first
 
 ZStack(alignment: .top) {
 Color.red
 Text("Hello world")
 }
 
 Colors as view
 
 ZStack(alignment: .top) {
 Color(red: 1, green: 0.8, blue: 0).frame(width: 200, height: 200)
 Text("Hello world")
 }
 
 Painting safe area
 
 ZStack(alignment: .top) {
 Color.red.edgesIgnoringSafeArea(.all)
 Text("Hello world")
 }
 
 Gradients
 An array of colors to show
 Size and direction information
 The type of gradient to use
 
 Linear gradient
 
 LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
 .edgesIgnoringSafeArea(.all)
 
 Radial gradient
 
 RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 1, endRadius: 200)
 .edgesIgnoringSafeArea(.all)
 
 Angular gradients
 
 AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center, startAngle: Angle(degrees: 100), endAngle: Angle(degrees: 360))
 AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
 
 Images
 
 Image("pencil") will load an image called “Pencil” that you have added to your project.
 Image(decorative: "pencil") will load the same image, but won’t read it out for users who have enabled the screen reader. This is useful for images that don’t convey additional important information.
 Image(systemName: "pencil") will load the pencil icon that is built into iOS. This uses Apple’s SF Symbols icon collection, and you can search for icons you like – download Apple’s free SF Symbols app from the web to see the full set.
 
 Simple button with text
 Button("Tap me") {
 print("hey")
 }
 
 Custom button with image and title
 Button(action: {
 print("hey")
 }) {
 HStack{
 Image(systemName: "pencil")
 .renderingMode(.template)
 .foregroundColor(Color.red)
 Text("Edit")
 }
 }
 
 Alerts
 
 Button("Show Alert") {
 self.showingAlert = true
 }
 .alert(isPresented: $showingAlert) { () -> Alert in
 Alert(title: Text("Hello SwiftUI"), message: Text("This is some detail message"), dismissButton: .default(Text("Ok")))
 }
 
 alerts will show when your state are true! and keybinding will set to false when dismiss
 */

import SwiftUI

struct FlagImage: ViewModifier {
    
    var imageName: String
    func body(content: Content) -> some View {
            Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black,lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

extension View {
    func flagImage(named name: String) -> some View {
        self.modifier(FlagImage(imageName: name))
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    
    var body: some View {
        ZStack {
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(spacing: 30) {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .fixedSize()
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach (0..<3) {number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                        .flagImage(named: self.countries[number])
                    }
                }
                Spacer()
                Text("Your Score is: \(score) points")
                    .foregroundColor(.white)
                Spacer()
                    .alert(isPresented: $showingScore) { () -> Alert in
                        Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Ok"), action: {
                            self.askQuestion()
                        }))
                }
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        scoreMessage = ""
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
