//
//  SizePopUpView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI

struct SizePopUpView: View {
    
    @StateObject var popUp = AppState()
    //Binding var canvasData: AppState
    
//    @State private var width = ""
//    @State private var length = ""
//    @State private var wallHeight = ""
    @Binding var width: String
    @Binding var length: String
    @Binding var wallHeight: String
    
    @Binding  var sheetPresented: Bool
    @Binding  var isSetButtonTapped: Bool
    
    var isSetButtonEnabled: Bool {
        let isWidthValid = Double(width) ?? 0.0 >= 2
        let isLengthValid = Double(length) ?? 0.0 >= 2
        let isWallHeightValid = Double(wallHeight) ?? 0.0 >= 2
        return isWidthValid && isLengthValid && isWallHeightValid
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Set Room Size")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Width").bold()
                    HStack {
                        TextField("min. 2", text: $popUp.width)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Text("m")
                    }
                    .padding(.bottom)
                    
                    Text("Length").bold()
                    HStack {
                        TextField("min. 2", text: $popUp.length)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Text("m")
                    }
                    .padding(.bottom)
                    
                    
                    Text("Wall Height").bold()
                    HStack {
                        TextField("min. 2", text: $popUp.wallHeight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Text("m")
                    }
                    
                    Button(action: {
                        popUp.isSetButtonTapped = true
                        popUp.sheetPresented = false
                        print("width: \(popUp.width)")
                        print("length: \(popUp.length)")
                        print("wall: \(popUp.wallHeight)")
                        
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.08)
                            .foregroundColor(isSetButtonEnabled ?  .blue : .gray)
                        
                        
                            .overlay {
                                Text("Set")
                                    .font(.title3).bold()
                                    .foregroundColor(.white)
                            }
                    }
                    .disabled(!isSetButtonEnabled)
                    .padding(.top, 50)
                }
                .font(.title3)
                .padding()
                Spacer()
            }
            .padding(150)
        }
        
    }
}

#Preview {
    SizePopUpView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"), sheetPresented: Binding.constant(true), isSetButtonTapped: Binding.constant(false))
}
