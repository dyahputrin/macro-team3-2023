//
//  SizePopUpView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI

struct SizePopUpView: View {
    
    @Binding  var sheetPresented: Bool
    @Binding  var isSetButtonTapped: Bool
    
    var roomSceneViewModel: RoomSceneViewModel
    @Binding var sceneViewID: UUID
    @Binding var roomWidthText: String
    @Binding var roomLengthText: String
    @Binding var roomHeightText: String
    
    var isSetButtonEnabled: Bool {
        let isWidthValid = Double(roomWidthText) ?? 0.0 >= 2
        let isLengthValid = Double(roomLengthText) ?? 0.0 >= 2
        let isWallHeightValid = Double(roomHeightText) ?? 0.0 >= 2
        let areFieldsFilled = !roomWidthText.isEmpty && !roomLengthText.isEmpty && !roomHeightText.isEmpty
        return isWidthValid && isLengthValid && isWallHeightValid && areFieldsFilled
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    VStack {
                        Text("Set Room Size")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        
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
                                isSetButtonTapped = true
                                sheetPresented = false
                                print("width: \(roomWidthText)")
                                print("length: \(roomLengthText)")
                                print("wall: \(roomHeightText)")
                                
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
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.08)
                                    .foregroundColor(isSetButtonEnabled ?  .blue : .gray)
                                
                                
                                    .overlay {
                                        Text("Set")
                                            .font(.title3).bold()
                                            .foregroundColor(.white)
                                    }
                            }
                            .disabled(!isSetButtonEnabled)
                            .padding(.top, 50)
                        }
                        .font(.title3)
                        .padding()
                        Spacer()
                    }
                    .padding(.horizontal, 150)
                    .navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            sheetPresented = false // Dismiss the sheet
                        }) {
                            Image(systemName: "x.circle.fill")// Add a "Cancel" button
                                .foregroundColor(.systemGray2)
                        }
                    }
                    )
                }
                
            }
        }
        
        
        
        
    }
}

#Preview {
    SizePopUpView(
        sheetPresented: Binding.constant(true),
        isSetButtonTapped: Binding.constant(false),
        roomSceneViewModel: RoomSceneViewModel(roomSceneModel: RoomSceneModel(roomWidth: 0, roomHeight: 0, roomLength: 0)),
        sceneViewID: .constant(UUID()),
        roomWidthText: Binding.constant("2"),
        roomLengthText: Binding.constant("2"),
        roomHeightText: Binding.constant("2")
    )
}
