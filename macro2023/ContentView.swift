//
//  ContentView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationStack {
                NavigationLink(destination: CanvasView()) {
                    Text("Go to Canvas")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
