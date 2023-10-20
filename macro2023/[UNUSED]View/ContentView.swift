//
//  ContentView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 20/10/23.
//

import Foundation


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination:
                            CanvasView(objectsButtonClicked: false, roomButtonClicked: false, viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false))
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

#Preview {
    ContentView()
}
