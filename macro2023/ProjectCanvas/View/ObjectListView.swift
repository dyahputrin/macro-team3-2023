//
//  ObjectListView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 24/10/23.
//

import SwiftUI

struct ObjectListView: View {
    //@State private var showingObjectList = false
    
    @Binding var showingObjectList: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.25
    var sideBarHeight = UIScreen.main.bounds.size.height * 0.4
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        Spacer()
        HStack {
            ZStack(alignment: .top) {
                VStack(alignment: .leading, content: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.systemGray6)
                        .frame(width: sideBarWidth, height: sideBarHeight)
                        .overlay(
                            VStack(alignment: .leading) {
                                Text("Objects in Canvas")
                                    .font(.headline)
                                    .bold()
                                    .padding(.top)
                                    .padding(.horizontal, 30)
                                ScrollView(.vertical) {
                                    LazyVGrid(columns: columns, spacing: 3) {
                                        ForEach(1..<21, id: \.self) { index in
                                            Button(action: {})
                                            {
                                                Text("My Object \(index)")
                                                    .underline()
                                                    .font(.subheadline)
                                                    .padding(.vertical, 10)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                                .frame(width: sideBarWidth, height: sideBarHeight - 20)
                                //.frame(width: 320, height: 380)
                            
                        )
                })
                
                MenuChevron
                    .foregroundColor(Color.systemGray6)
            }
            .frame(width: sideBarWidth)
            .offset(x: showingObjectList ? 0 : -sideBarWidth)
            .animation(.default, value: showingObjectList)
            Spacer()
        }
    }
    
    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: 45))
                .offset(x: showingObjectList ? -18 : -10)
                .onTapGesture {
                    showingObjectList.toggle()
                }

            Image(systemName: "chevron.right")
                .foregroundColor(.black)
                .bold()
                .rotationEffect(
                  showingObjectList ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: showingObjectList ? -4 : 8)
                .foregroundColor(Color.systemGray6)
        }
        .offset(x: sideBarWidth / 2, y: 8)
        .animation(.default, value: showingObjectList)
    }
}

#Preview {
    ObjectListView(showingObjectList: .constant(true))
}
