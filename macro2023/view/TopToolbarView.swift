//
//  TopToolbarView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI

struct TopToolbarView: View {
    @State private var projectName = "New Project"
    @State private var roomButtonClicked = false
    @State private var objectsButtonClicked = false
    @State private var viewfinderButtonClicked = false
    @State private var isExporting = false
    @State private var showSaveAlert = false
    @State private var renameClicked = false
    @State private var newProjectName = ""

    
    //@ObservedObject var toolbarData = AppState()
    
//    @Binding var projectName: String
//    @Binding var roomButtonClicked: Bool
//    @Binding var objectsButtonClicked: Bool
//    @Binding var viewfinderButtonClicked: Bool
    
    //@Binding var isExporting: Bool
    //@Binding var document: MessageDocument
    
    var body: some View {
        if objectsButtonClicked == true {
            ObjectSidebarView()
                .transition(.moveAndFade)
            
        } else if roomButtonClicked == true {
            RoomSidebarView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"))
                .transition(.moveAndFade)
        }
        Text(projectName)
            .toolbarRole(.editor)
            .toolbarBackground(Color.systemGray6)
            .toolbar {
                ToolbarItemGroup {
                    HStack {
                        //VIEWFINDER
                        Menu {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Scan objects")
                            })
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Scan room")
                            })
                        } label: {
                            Label("Viewfinder", systemImage: "viewfinder")
                                .foregroundColor(.black)
                        }
                        
                        // ROOM
                        Button(action : {
                            roomButtonClicked.toggle()
                            objectsButtonClicked = false
                        }) {
                            Image(systemName: "square.split.bottomrightquarter")
                                .foregroundColor(roomButtonClicked ? .blue : .black)
                                .padding()
                        }
                        
                        //OBJECTS
                        Button(action : {
                            objectsButtonClicked.toggle()
                            roomButtonClicked = false
                        }) {
                            Image(systemName: "chair.lounge")
                                .foregroundColor(objectsButtonClicked ? .blue : .black)
                        }
                    }
                    .padding(.trailing, 100)
                }
                
                // UNDO & SAVE
                ToolbarItemGroup {
                    Button(action: {})
                    {
                        Image(systemName: "arrow.uturn.backward.circle")
                            .foregroundColor(.black)
                            .padding()
                    }
                    Button(action: {
                        showSaveAlert = true
                    })
                    {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.black)
                    }.alert(isPresented: $showSaveAlert) {
                        Alert(
                            title: Text("\(projectName) Saved"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .navigationTitle(projectName)
            .toolbarTitleMenu {
                Button(action: {
                    renameClicked = true
                    print("Action for context menu item 1")
                    //TextField("\(projectName)", text: $projectName)
                }) {
                    Label("Rename", systemImage: "pencil")
                }
                Button(action: {
                    isExporting = true
                    print("Action for context menu item 2")
                }) {
                    Label("Export as USDZ", systemImage: "square.and.arrow.up")
                }
            }
            .alert("Rename", isPresented: $renameClicked, actions: {
                TextField("\(projectName)", text: $newProjectName)
                Button("Save", action: {
                    projectName = newProjectName
                    renameClicked = false
                })
                Button("Cancel", role: .cancel, action: {
                    renameClicked = false
                })
            })
    }
}

#Preview {
//    TopToolbarView(projectName: .constant("New Project"), roomButtonClicked: .constant(false), objectsButtonClicked: .constant(false), viewfinderButtonClicked: .constant(false), isExporting: .constant(false))
    TopToolbarView()
}

//
//VStack {
//                if isEditingTitle {
//                    TextField("Project Name", text: $projectName)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//                } else {
//                    Text(projectName)
//                        .font(.title)
//                        .onTapGesture {
//                            isEditingTitle = true
//                        }
//                }
//
//                Spacer()
//            }
