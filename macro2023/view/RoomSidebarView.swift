//
//  RoomSidebarView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI

struct RoomSidebarView: View {
   // @ObservedObject var roomSidebar = AppState()
    
    @State private var isSetButtonSidebarTapped = false 
    
    @State private var currentSection = "Room Size"
    var section = ["Room Size", "Imports"]
    
    @Binding var roomWidth: String
    @Binding var roomLength: String
    @Binding var wallHeight: String
    //@Binding var isSetButtonTapped: Bool
    
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
                                            TextField("min. 2", text: $roomWidth)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        .padding(.bottom)
                                        
                                        Text("Length").bold()
                                        HStack {
                                            TextField("min. 2", text: $roomLength)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        .padding(.bottom)
                                        
                                        
                                        Text("Wall Height").bold()
                                        HStack {
                                            TextField("min. 2", text: $wallHeight)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        
                                        Button(action: {
                                            isSetButtonSidebarTapped = true
                                            print("width: \($roomWidth)")
                                            print("length: \($roomLength)")
                                            print("wall: \($wallHeight)")
                                            
                                        }) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.08)
                                                .foregroundColor(.blue)
                                            
                                            
                                                .overlay {
                                                    Text("Set")
                                                        .font(.title3).bold()
                                                        .foregroundColor(.white)
                                                }
                                        }
                                        .padding(.top, 40)
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
                    .padding(.top, 10)
                
            }
        }
    }
}


#Preview {
    RoomSidebarView(roomWidth: .constant("2"), roomLength: .constant("2"), wallHeight: .constant("2"))
}
