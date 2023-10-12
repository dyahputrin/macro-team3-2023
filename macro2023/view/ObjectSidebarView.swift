//
//  ObjectSidebarView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI

struct ObjectSidebarView: View {
    @State private var currentSection = "Objects"
    var section = ["Objects", "Imports"]
    
    var body: some View {
        
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            GeometryReader { geometry in
                VStack {
                    Picker("", selection: $currentSection) {
                        ForEach(section, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if currentSection == "Objects" {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 30) {
                                
                                ForEach(1..<15, id: \.self) { index in
                                    Image(systemName: "plus.app.fill")
                                        .frame(width: 100, height: 100)
                                        .font(.system(size: 100))
                                        .shadow(radius: 5)
                                }
                            }
                            .padding(.vertical)
                        }
                    } else if currentSection == "Imports" {
                        ScrollView {
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
    ObjectSidebarView()
}
