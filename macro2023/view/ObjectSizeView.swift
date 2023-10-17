//
//  ObjectSizeView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 17/10/23.
//

import SwiftUI

struct ObjectSizeView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.systemGray6)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            .shadow(radius: 3)
            .frame(width: 200, height: 120)
            .overlay(
                VStack(alignment: .leading, content: {
                    Text("Width         : " + "-")
                    Text("Length       : " + "-")
                    Text("Height        : " + "-")
                })
                .font(.title3)
                .bold()
                .padding(.leading, -50)
            )
    }
}

#Preview {
    ObjectSizeView()
}
