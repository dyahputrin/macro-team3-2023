//
//  SizePopUpView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI

struct SizePopUpView: View {
    
   // @ObservedObject var popUp = AppState()
    //Binding var canvasData: AppState
    
    @State private var roomWidth = ""
    @State private var roomLength = ""
    @State private var wallHeight = ""

//    @Binding var width: String
//    @Binding var length: String
//    @Binding var wallHeight: String
    
    @Binding  var sheetPresented: Bool
    @Binding  var isSetButtonTapped: Bool
    
    var isSetButtonEnabled: Bool {
        let isWidthValid = Double(roomWidth) ?? 0.0 >= 2
        let isLengthValid = Double(roomLength) ?? 0.0 >= 2
        let isWallHeightValid = Double(wallHeight) ?? 0.0 >= 2
        let areFieldsFilled = !roomWidth.isEmpty && !roomLength.isEmpty && !wallHeight.isEmpty
        return isWidthValid && isLengthValid && isWallHeightValid && areFieldsFilled
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
                        TextField("min. 2", text: $roomWidth)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Text("m")
                    }
                    .padding(.bottom)
                    
                    Text("Length").bold()
                    HStack {
                        TextField("min. 2", text: $roomLength)
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
                        isSetButtonTapped = true
                        sheetPresented = false
                        print("width: \(roomWidth)")
                        print("length: \(roomLength)")
                        print("wall: \(wallHeight)")
                        
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
//    SizePopUpView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"), sheetPresented: Binding.constant(true), isSetButtonTapped: Binding.constant(false))
    
    SizePopUpView(sheetPresented: Binding.constant(true), isSetButtonTapped: Binding.constant(false))
}
