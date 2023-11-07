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
    
    @State var objectName = "Selected Object Name"
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.systemGray6)
                    .frame(width: 250, height: 150)
                    .overlay(
                        VStack(alignment: .leading, content: {
                            HStack {
                                Text("\(objectName)")
                                    .bold()
                                    .font(.title3)
                                    .bold()
                                //.padding(.top)
                                    .lineLimit(2)
                                
                                Spacer()
//                                HStack(alignment: .firstTextBaseline) {
//                                    Button(action: {})
//                                    {
//                                        Text("REMOVE")
//                                            .underline()
//                                            .foregroundColor(.red)
//                                            .font(.subheadline)
//                                            .bold()
//                                        //.padding(.leading, 50)
//                                    }
//                                }
                            }
                            .padding(.horizontal)
                            
                            VStack {
                                Text("W :   \(roomWidthText) m")
                                Text("L :   \(roomLengthText) m")
                                Text("H :   \(roomHeightText) m")
                            }
                            .padding()
                        })
                        .padding(.top)
                    )
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading)
                Spacer()
            }
        }
    }
}

#Preview {
    ObjectSizeView(roomWidthText:.constant("2.00"), roomLengthText: .constant("2.00"), roomHeightText: .constant("2.00"), sceneViewID: .constant(UUID()), roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()))
}
