//
//  CanvasView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

struct CanvasView: View {
    var body: some View {
        NavigationStack{
            RoomSceneView()
                .padding()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                        Spacer()
                        Text("Untitled")
                        Spacer()
                        
                        Button(action: {
                            print("Walls clicked")
                        }) {
                            VStack {
                                Image(systemName: "bell")
                                Text("Walls")
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print("Object clicked")
                        }) {
                            VStack {
                                Image(systemName: "plus")
                                Text("Objects")
                            }
                        }
                        Spacer()
                        
                        Button(action: {
                            print("Object clicked")
                        }) {
                            VStack {
                                Image(systemName: "arrow.uturn.backward.circle")
                            }
                        }
                        Spacer()
                        
                        Button(action: {
                            print("Object clicked")
                        }) {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                    }
                }
        }
    }
}

#Preview {
    CanvasView()
}
