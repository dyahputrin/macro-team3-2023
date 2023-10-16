//
//  ContentView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isRoomCaptureViewPresented = false
    
    var body: some View {
        VStack {
            Button(action: {
                isRoomCaptureViewPresented = true
           }) {
               Text("Open Room Capture")
           }
           .fullScreenCover(isPresented: $isRoomCaptureViewPresented) {
               ZStack {
                   OnboardingViewControllerWrapper()
                   VStack {
                       HStack {
                           Button("Cancel") {
                               isRoomCaptureViewPresented = false
                           }.buttonStyle(.automatic)
                           
                           Spacer()
                       }
                       .padding()
                       
                       Spacer()
                   }
               }
           }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
