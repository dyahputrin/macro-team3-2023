//
//  Test.swift
//  macro2023
//
//  Created by Oey Darryl Valencio Wijaya on 10/10/23.
//

import SwiftUI

struct Test: View {
    
    private let items = (1...50).map { "Project \($0)" }
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                        .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

#Preview {
    Test()
}
