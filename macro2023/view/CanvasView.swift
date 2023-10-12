//
//  CanvasView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI

struct CanvasView: View {
//    @State private var sheetPresented = true
//    @State private var isSetButtonTapped = false 
    @StateObject var canvasData = AppState()
    
    @Binding var sheetPresented: Bool
    @Binding var isSetButtonTapped: Bool
    
    @Binding var objectsButtonClicked: Bool
    @Binding var roomButtonClicked: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    TopToolbarView(projectName: .constant("New Project"), roomButtonClicked: .constant(false), objectsButtonClicked: .constant(false), viewfinderButtonClicked: .constant(false))
                    
                    //if !sheetPresented {
                    if roomButtonClicked {
                        Rectangle()
                            .frame(width: geometry.size.width * 0.3)
                            .background(Color.clear)
                            .overlay(RoomSidebarView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"), isSetButtonTapped: .constant(false)))
                    }
                    //}
                    
                }
                .onAppear {
                    canvasData.sheetPresented = true
                }
                //        .sheet(isPresented: $canvasData.sheetPresented) {
                //            SizePopUpView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"), sheetPresented: Binding.constant(true), isSetButtonTapped: Binding.constant(false))
                //                .interactiveDismissDisabled()
                //        }
            }
        }
    }
}

#Preview {
    CanvasView(sheetPresented: .constant(true), isSetButtonTapped: .constant(false), objectsButtonClicked: .constant(false), roomButtonClicked: .constant(false))
}
