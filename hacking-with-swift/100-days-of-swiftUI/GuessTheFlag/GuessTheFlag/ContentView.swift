//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by rafaeldelegate on 10/13/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import SwiftUI

struct FlagImage: ViewModifier {
    let name: String
   
    func body(content: Content) -> some View {
        Image(name)
        .renderingMode(.original)
        .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
extension View {
    func renderImage(with name: String) -> some View {
        self.modifier(FlagImage(name: name))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia","France","Germany","Ireland","Nigeria","Russia","Poland","Italy","Spain","UK","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var isShowingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var correct = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag off")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderImage(with: self.countries[number])
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                        .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                        
                        
                    }
                    
                }
                Text("Score \(score)")
                Spacer()
            }
        }
        .alert(isPresented: $isShowingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)."), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct "
            score += 1
            correct = true
        } else {
            scoreTitle = "Wrong thats the flag of \(countries[number])"
            score -= 1
            correct = false
        }
        
        isShowingScore = true
    }
    
    func askQuestion() {
       countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
