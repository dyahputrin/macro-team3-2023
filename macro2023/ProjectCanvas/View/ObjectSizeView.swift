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
    @EnvironmentObject var routerView: RouterView
    
    @FetchRequest(entity: ObjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ObjectEntity.importedName, ascending: true)])
    var importsObject: FetchedResults<ObjectEntity>
    
    @ObservedObject var roomSceneViewModel:CanvasDataViewModel
    @ObservedObject var objectDimensionData: ObjectDimensionData
    
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.thinMaterial)
                    .frame(width: 250, height: 180)
                    .overlay(
                        VStack(alignment: .leading, content: {
                            HStack {
                                Text("\(objectDimensionData.name)")
                                    .bold()
                                    .font(.title3)
                                    .bold()
                                    .lineLimit(2)
                                
                                Spacer()
                                HStack(alignment: .firstTextBaseline) {
                                    Button(action: {
                                        print(roomSceneViewModel.listChildNodes)
                                        for cNode in roomSceneViewModel.listChildNodes{
                                            if objectDimensionData.selectedChildNode.name == cNode.childNodes[0].childNodes[0].name{
                                                roomSceneViewModel.listChildNodes.removeAll { i in
                                                    i == cNode
                                                }
                                            }
                                        }
                                        objectDimensionData.selectedChildNode.removeFromParentNode()
                                    })
                                    {
                                        Image(systemName: "trash.fill")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
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
                        .padding(.vertical)
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
