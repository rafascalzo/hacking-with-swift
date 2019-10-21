//
//  ContentView.swift
//  ViewModifierChallenge
//
//  Created by rafaeldelegate on 10/20/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 30))
            .foregroundColor(Color.blue)
    }
}
extension View {
    func proeminentTitleStyle() -> some View {
        self.modifier(Title())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello World")
        .proeminentTitleStyle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
