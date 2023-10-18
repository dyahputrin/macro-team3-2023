//
//  Sidebar.swift
//  macro2023
//
//  Created by Oey Darryl Valencio Wijaya on 18/10/23.
//

import SwiftUI

struct Sidebar: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: UIProject()) {
                    Label("All Projects", systemImage:  "square.fill.on.square.fill")
                }
                .foregroundStyle(Color(hex: 0x28B0E5))
                Label("Recents", systemImage: "square.fill.on.square.fill")
                    .foregroundStyle(Color(hex: 0xFF9500))
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Solulu")
//            .colorMultiply(Color(hex: 0xEBEBF5))
        }
    }
}

#Preview {
    Sidebar()
        .previewInterfaceOrientation(.landscapeRight)
}
