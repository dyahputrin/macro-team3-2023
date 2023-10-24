//
//  ObjectSizeView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 24/10/23.
//

import SwiftUI

struct ObjectSizeView: View {
    @Binding var roomWidthText: String
    @Binding var roomLengthText: String
    @Binding var roomHeightText: String
    @Binding var sceneViewID: UUID
    var roomSceneViewModel: CanvasDataViewModel
    
    var body: some View {
        
        // ONLY SHOW THE SIZE OF SELECTED OBJECT
//        Rectangle()
//            .foregroundColor(Color.systemGray6)
//            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
//            .frame(width: 170, height: 100)
//            .overlay(
//                VStack(alignment: .leading, content: {
//                    Text("Width     :   \(roomWidthText)    m")
//                    Text("Length    :   \(roomLengthText)   m")
//                    Text("Height    :   \(roomHeightText)   m")
//                })
//                .padding(.leading)
//                .font(.subheadline)
//                .padding(.leading, -50)
//            )
        
        // SHOW NAME & SIZE OF SELECTED OBJECT WITH DELETE BUTTON (1)
//        Rectangle()
//            .foregroundColor(Color.systemGray6)
//            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
//            .frame(width: 200, height: 150)
//            .overlay(
//                VStack(alignment: .leading, content: {
//                    HStack {
//                        Text("Object Name")
//                            .bold()
//                            .font(.headline)
//                        //Spacer()
//                        Image(systemName: "trash")
//                            .foregroundColor(.red)
//                            .bold()
//                            .padding(.leading)
//                        //Spacer()
//                    }
//                    .padding(.top)
//                    
//                    VStack {
//                        Text("Width     :   \(roomWidthText)    m")
//                        Text("Length    :   \(roomLengthText)   m")
//                        Text("Height    :   \(roomHeightText)   m")
//                    }
//                    .padding(.vertical)
//                })
//                .padding(.leading, -10)
//                .font(.subheadline)
//               //.padding(.leading, -50)
//            )
        
        // SHOW NAME & SIZE OF SELECTED OBJECT WITH DELETE BUTTON (2)
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color.systemGray6)
            //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            .frame(width: 300, height: 120)
            .overlay(
                VStack(alignment: .center, content: {
                    HStack {
                        Text("Object Name")
                            .bold()
                            .font(.title3)
                            .bold()
                        //Spacer()
                        //Image(systemName: "trash")
                        Text("REMOVE")
                            .underline()
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .bold()
                            .padding(.leading, 50)
                        //Spacer()
                    }
                    .padding(.top)
                    
                    HStack {
                        Text("W:   \(roomWidthText) m    ")
                        Text("L:   \(roomLengthText) m    ")
                        Text("H:   \(roomHeightText) m")
                    }
                    .padding(.vertical)
                })
                //.padding(.leading, -10)
                //.font(.subheadline)
               //.padding(.leading, -50)
            )
        
//        VStack(alignment: .leading, content: {
//            HStack {
//                Text("Object Name")
//                    .font(.title3)
//                    .bold()
//                Text("REMOVE")
//                    .foregroundColor(.red)
//                    .underline()
//                    .bold()
//                    .padding(.leading, 50)
//            }
//            .padding(.top)
//            
//            VStack {
//                HStack {
//                    Text("W:   \(roomWidthText) m    ")
//                    Text("L:   \(roomLengthText) m    ")
//                    Text("H:   \(roomHeightText) m")
//                }
//            }
//            .padding(.vertical)
//        })
//        .padding()
//        .background(Color.systemGray6)
//        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ObjectSizeView(roomWidthText:.constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()), roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()))
}
