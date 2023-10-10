//
//  ChangeName.swift
//  macro2023
//
//  Created by Billy Jefferson on 09/10/23.
//

import SwiftUI

struct ChangeName: View {
    @State private var tripName = ""
    var body: some View {
        NavigationStack {
            VStack {
                Text("Give Your Trip A Name!")
                TextField("Trip Name", text: $tripName)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                Button(
                    action: {
                    }
                ) {
                    Spacer()
                    Text("Create Trip!")
                    Spacer()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(Color.white)
                .padding(.horizontal, 14)
            }
        }
    }
}
#Preview {
    ChangeName()
}
