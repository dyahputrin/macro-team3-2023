//
//  RoomSidebarView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI

struct RoomSidebarView: View {
    
    @State private var isSetButtonSidebarTapped = false
    
    @State private var currentSection = "Room Size"
    var section = ["Room Size", "Imports"]
    
    @Binding var roomWidthText: String
    @Binding var roomLengthText: String
    @Binding var roomHeightText: String
    @Binding var sceneViewID: UUID
    var roomSceneViewModel: CanvasDataViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color.systemGray6)
                    .overlay (
                        VStack {
                            Picker("", selection: $currentSection) {
                                ForEach(section, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            if currentSection == "Room Size" {
                                GeometryReader { geometry in
                                    VStack(alignment: .leading) {
                                        Text("Width").bold()
                                        HStack {
                                            TextField("min. 2", text: $roomWidthText)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        .padding(.bottom)
                                        
                                        Text("Length").bold()
                                        HStack {
                                            TextField("min. 2", text: $roomLengthText)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        .padding(.bottom)
                                        
                                        
                                        Text("Wall Height").bold()
                                        HStack {
                                            TextField("min. 2", text: $roomHeightText)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        
                                        Button(action: {
                                            isSetButtonSidebarTapped = true
                                            if let width = roomSceneViewModel.stringToCGFloat(value: roomWidthText),
                                               let height = roomSceneViewModel.stringToCGFloat(value: roomHeightText),
                                               let length = roomSceneViewModel.stringToCGFloat(value: roomLengthText) {
                                                roomSceneViewModel.updateRoomSize(width: width, height: height, length: length)
                                                sceneViewID = UUID()
                                            } else {
                                                // Handle invalid input
                                            }
                                            
                                        }) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.07)
                                            
                                                .overlay {
                                                    Text("Set")
                                                        .font(.title3).bold()
                                                        .foregroundColor(.white)
                                                }
                                        }
                                        .padding(.top, 30)
                                    }
                                    .padding()
                                }
                                
                            } else if currentSection == "Imports" {
                                ScrollView {
                                    let columns = [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ]
                                    LazyVGrid(columns: columns, spacing: 30) {
                                        ImportButtonView(isImporting: .constant(false))
                                        
                                        ForEach(2..<15, id: \.self) { index in
                                            Image(systemName: "plus.app.fill")
                                                .frame(width: 100, height: 100)
                                                .font(.system(size: 100))
                                                .shadow(radius: 5)
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                            
                        }
                            .padding()
                            .background(Color.systemGray6)
                    )
                    .frame(width: geometry.size.width * 0.3)
                    .padding(.top, 1)
                
            }
        }
    }
}


#Preview {
    RoomSidebarView(roomWidthText:.constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()), roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()))
}
