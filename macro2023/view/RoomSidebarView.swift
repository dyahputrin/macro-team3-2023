//
//  RoomSidebarView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI

struct RoomSidebarView: View {
    @StateObject var roomSidebar = AppState()
    
    @State private var currentSection = "Room Size"
    var section = ["Room Size", "Imports"]
    
    @Binding var width: String
    @Binding var length: String
    @Binding var wallHeight: String
    @Binding var isSetButtonTapped: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Picker("", selection: $currentSection) {
                    ForEach(section, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if currentSection == "Room Size" {
                    GeometryReader { geometry in
                        VStack(alignment: .leading) {
                            Text("Width").bold()
                            HStack {
                                TextField("min. 2", text: $width)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                Text("m")
                            }
                            .padding(.bottom)
                            
                            Text("Length").bold()
                            HStack {
                                TextField("min. 2", text: $length)
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
                                roomSidebar.isSetButtonTapped = true
                                print("width: \(width)")
                                print("length: \(length)")
                                print("wall: \(wallHeight)")
                                
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
                            ImportButtonView()
                            
                            ForEach(2..<15, id: \.self) { index in
                                Image(systemName: "plus.app.fill")
                                    .frame(width: 100, height: 100)
                                    .font(.system(size: 100))
                                    .shadow(radius: 5)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                
            }
            .background(Color.systemGray4)
            .frame(width: geometry.size.width * 0.3)
            .padding()
        }
    }
}


#Preview {
    RoomSidebarView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"), isSetButtonTapped: .constant(false))
}
