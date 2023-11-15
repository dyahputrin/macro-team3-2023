//
//  ObjectListView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 24/10/23.
//

import SwiftUI

struct ObjectListView: View {
    @Binding var showingObjectList: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.2
    var sideBarHeight = UIScreen.main.bounds.size.height
    @State private var selectedObject: Int?
    @State private var selectedWall: Int?
    @State var wallList = true
    @State var objectList = true
    @ObservedObject var objectDimensionData: ObjectDimensionData
    @ObservedObject var roomSceneViewModel:CanvasDataViewModel
    
    var body: some View {
        HStack {
            ZStack(alignment: .top) {
                MenuChevron
                List {
                    Section(isExpanded: $wallList,
                            content: {
                        
                        ForEach(roomSceneViewModel.listWallNodes , id:\.self){ wallNodes in
                            if roomSceneViewModel.canvasData.roomWidth != 0 && roomSceneViewModel.canvasData.roomHeight != 0 && roomSceneViewModel.canvasData.roomLength != 0{
                                HStack{
                                    let indexWall = roomSceneViewModel.listWallNodes.firstIndex(of:wallNodes)
                                    Text("\(wallNodes.name!)")
                                        .foregroundColor(roomSceneViewModel.isWallHidden[indexWall!] ? .gray : . black)
                                    Spacer()
                                    Image(systemName: roomSceneViewModel.isWallHidden[indexWall!] ? "eye.slash" : "eye")
                                        .foregroundColor(roomSceneViewModel.isWallHidden[indexWall!] ? Color.gray : Color.accentColor)
                                        .onTapGesture {
                                            wallNodes.isHidden.toggle()
                                            roomSceneViewModel.isWallHidden[indexWall!] = wallNodes.isHidden
                                        }
                                }
                            }
                        }
                        
                    }, header: {
                        Image(systemName: "square.split.bottomrightquarter")
                        Text("Wall List")
                    })
                    Section(isExpanded: $objectList, content: {
                        ForEach(roomSceneViewModel.listChildNodes , id:\.self) { item in
                            HStack {
                                if let indexObject = roomSceneViewModel.listChildNodes.firstIndex(of: item) {
                                    if (roomSceneViewModel.listChildNodes[indexObject].childNodes.first?.childNodes.first) != nil {
                                        Text(roomSceneViewModel.renamedNode[indexObject])
                                            .foregroundColor(roomSceneViewModel.isObjectHidden[indexObject] ? .gray : .black)
                                    }
                                    Spacer()
                                    Image(systemName: roomSceneViewModel.isObjectHidden[indexObject] ? "eye.slash" : "eye")
                                        .foregroundColor(roomSceneViewModel.isObjectHidden[indexObject] ? Color.gray : Color.accentColor)
                                        .onTapGesture {
                                            item.isHidden.toggle()
                                            roomSceneViewModel.isObjectHidden[indexObject] = item.isHidden
                                        }
                                }
                            }
                            .swipeActions {
                                Button(action: {
                                    item.removeFromParentNode()
                                    if let index = roomSceneViewModel.listChildNodes.firstIndex(of: item) {
                                        roomSceneViewModel.listChildNodes.remove(at: index)
                                        roomSceneViewModel.renamedNode.remove(at: index)
                                        roomSceneViewModel.isObjectHidden.remove(at: index)
                                    }
                                }) {
                                    Text("Remove")
                                        .foregroundColor(Color.white)
//                                        .background(Color.red)
                                }
                                .tint(.red)
                            }
                        }
                    }, header: {
                        Image(systemName: "chair.lounge")
                        Text("Object List")
                    })

                }
                .background(.regularMaterial)
                .scrollContentBackground(.hidden)
                .listStyle(.sidebar)
            }
            .frame(width: sideBarWidth)
            .offset(x: showingObjectList ? 0 : -sideBarWidth)
            .animation(.default, value: showingObjectList)
            Spacer()
        }
        .padding(.top, 1)
        .font(.subheadline)
        .animation(.easeInOut(duration: 5), value: showingObjectList)
    }
    
    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 70, height: 100)
                .offset(x: showingObjectList ? -18 : -15)
                .onTapGesture {
                    showingObjectList.toggle()
                }
                .foregroundStyle(.regularMaterial)
            
            Image(systemName: "chevron.right")
                .bold()
                .rotationEffect(
                    showingObjectList ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: 2)
                .foregroundColor(.gray)
                .font(.title3)
        }
        .offset(x: sideBarWidth / 1.8, y: 20)
        
    }
    
    func deleteListItem(at offsets: IndexSet) {
        roomSceneViewModel.listChildNodes.remove(atOffsets: offsets)
        // Perform any additional cleanup or data updates as needed
    }
}


//#Preview {
//    ObjectListView(showingObjectList: .constant(true))
//}
