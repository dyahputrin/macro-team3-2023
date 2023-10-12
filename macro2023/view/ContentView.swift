//
//  ContentView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination:
                            CanvasView(sheetPresented: .constant(true), isSetButtonTapped: .constant(false), objectsButtonClicked: .constant(false), roomButtonClicked: .constant(false))
            ) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    ContentView()
        .previewInterfaceOrientation(.landscapeLeft)
}
