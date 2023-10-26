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
            Image(systemName: "plus")
                .font(.system(size: 80))
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    ImportButtonView(isImporting: .constant(false))
}
