//
//  CanvasView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI
import Combine

struct CanvasView: View {
    
    var body: some View {
        NavigationStack{
            VStack {
                RoomSceneView()
                .padding()
            }
        }
    }
}

#Preview {
    CanvasView()
}
