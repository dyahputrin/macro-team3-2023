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
    
    @ObservedObject var objectDimensionData: ObjectDimensionData
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: 15)
//                    .foregroundColor(Color.systemGray6)
                    .foregroundStyle(.thinMaterial)
                    .frame(width: 250, height: 180)
                    .overlay(
                        VStack(alignment: .leading, content: {
                            HStack {
                                Text("\(objectDimensionData.name)")
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
//                            .padding(.top)
                            
                            VStack() {
                                HStack {
                                    Text("W:   ")
                                    Text("\(objectDimensionData.width) m    ")
                                }
                                .padding(.bottom, 2)
                                HStack {
                                    Text("L:   ")
                                    Text("\(objectDimensionData.length) m    ")
                                }
                                .padding(.bottom, 2)
                                HStack {
                                    Text("H:   ")
                                    Text("\(objectDimensionData.height) m    ")
                                }
                            }
                            .padding(.top)
                            .padding(.leading)
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

//#Preview {
//    ObjectSizeView(roomWidthText:.constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()), roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()))
//}
