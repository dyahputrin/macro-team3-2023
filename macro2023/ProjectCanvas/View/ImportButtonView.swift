//
//  ImportButtonView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI

struct ImportButtonView: View {
    @ObservedObject var importButton = AppState()
    
    @Binding var isImporting: Bool
    //@Binding var document: MessageDocument
    
    var body: some View {
        Button(action: {
            isImporting = true
        }) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .shadow(radius: 5)
                .overlay(
                    Image(systemName: "plus")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 50))
                )
        }
    }
}

#Preview {
    ImportButtonView(isImporting: .constant(false))
}
