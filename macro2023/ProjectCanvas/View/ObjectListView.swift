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
    @State var isWallHidden: [Bool] = [false, false, false, false]
    @State var isObjectHidden: [Bool] = [false, false, false, false]
    @State var objects: [String] = [
        "Object 1",
        "Object 2",
        "Object 3",
        "Object 4"
    ]
    
    var body: some View {
        let walls = [
            "Wall 1",
            "Wall 2",
            "Wall 3",
            "Wall 4"
        ]
        
        HStack {
            ZStack(alignment: .top) {
                
                MenuChevron
                
                List {
                    Section(isExpanded: $wallList,
                        content: {
                        ForEach(walls.indices, id: \.self) { index in
                            HStack {
                                Text(walls[index])
                                    .foregroundColor(isWallHidden[index] ? .gray : .black)
                                Spacer()
                                Button(action: {
                                    selectWall(index)
                                }, label: {
                                    if !isWallHidden[index] {
                                        Image(systemName: "eye")
                                            .foregroundColor(Color.accentColor)
                                            .onTapGesture {
                                                isWallHidden[index].toggle()
                                            }
                                    } else if isWallHidden[index] {
                                        Image(systemName: "eye.slash")
                                            .foregroundColor(.gray)
                                            .onTapGesture {
                                                isWallHidden[index].toggle()
                                            }
                                    }
                                })
                               
                            }
                            .listRowBackground(
                                       selectedWall == index ? Color.accentColor.opacity(0.2) : Color.white
                                   )
                        }
                    }, header: {
                        Image(systemName: "square.split.bottomrightquarter")
                        Text("Wall List")
                    }).onChange(of: isWallHidden) {
                        if let selectedWall = selectedWall, isWallHidden[selectedWall] {
                            self.selectedWall = nil
                        }
                    }
                    
                    Section(isExpanded: $objectList,
                        content: {
                        ForEach(objects.indices, id: \.self) { index in
                            HStack {
                                Text(objects[index])
                                    .foregroundColor(isObjectHidden[index] ? .gray : .black)
                                Spacer()
                                Button(action: {
                                    selectObject(index)
                                }, label: {
                                    if !isObjectHidden[index] {
                                        Image(systemName: "eye")
                                            .foregroundColor(Color.accentColor)
                                            .onTapGesture {
                                                isObjectHidden[index].toggle()
                                            }
                                    } else if isObjectHidden[index] {
                                        Image(systemName: "eye.slash")
                                            .foregroundColor(.gray)
                                            .onTapGesture {
                                                isObjectHidden[index].toggle()
                                            }
                                    }
                                })
                            }
                            .listRowBackground(
                                       selectedObject == index ? Color.accentColor.opacity(0.15) : Color.white
                                   )
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive, action: {removeObject(at: index)}, label: {Text("Remove")})
                                    .tint(.red)
                            }
                        }
                    }, header: {
                        Image(systemName: "chair.lounge")
                        Text("Object List")
                    }).onChange(of: isObjectHidden) {
                        if let selectedObject = selectedObject, isObjectHidden[selectedObject] {
                            self.selectedObject = nil
                        }
                    }
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
    
    private func removeObject(at index: Int) {
        withAnimation{
            objects.remove(at: index)
            print(objects)
        }
    }
    
    private func selectWall(_ index: Int) {
        if selectedWall == index {
            selectedWall = nil
        } else if !isWallHidden[index] {
            selectedWall = index
            selectedObject = nil
        }
    }

    private func selectObject(_ index: Int) {
        if selectedObject == index {
            selectedObject = nil
        } else if !isObjectHidden[index] {
            selectedObject = index
            selectedWall = nil
        }
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
}

#Preview {
    ObjectListView(showingObjectList: .constant(true))
}
