//
//  ObjectListView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 24/10/23.
//

import SwiftUI

struct ObjectListView: View {
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        VStack(alignment: .leading, content: {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.systemGray6)
                .frame(width: 320, height: 400)
                .overlay(
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(1..<20, id: \.self) { index in
                                Text("My Object \(index)")
                                    .underline()
                                    .padding(.top, 20)
                            }
                        }
                        .padding()
                    }
                    .frame(width: 320, height: 380)
                )
        })
        //.background(Color.systemGray6)
        //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ObjectListView()
}
