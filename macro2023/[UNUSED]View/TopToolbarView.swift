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
    
    @State private var isRoomCaptureViewPresented = false

    
    @Binding var roomWidthText: String
    @Binding var roomLengthText: String
    @Binding var roomHeightText: String
    @Binding var sceneViewID: UUID
    var roomSceneViewModel: RoomSceneViewModel
    
    var body: some View {
        if objectsButtonClicked == true {
            ObjectSidebarView()
                .transition(.moveAndFade)
            
        } else if roomButtonClicked == true {
            RoomSidebarView(roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText,  sceneViewID: $sceneViewID, roomSceneViewModel: roomSceneViewModel)
                .transition(.moveAndFade)
                .zIndex(1)
        }
        Text(projectName)
            .toolbarRole(.editor)
            .toolbarBackground(Color.systemGray6)
            .toolbar {
                ToolbarItemGroup {
                    HStack {
                        //VIEWFINDER
                        Menu {
                            Button(action: {
                                
                            }, label: {
                                Text("Scan objects")
                            })
                            Button(action: {
                                self.isRoomCaptureViewPresented = true
                            }, label: {
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
            .fullScreenCover(isPresented: $isRoomCaptureViewPresented) {
                ZStack {
                    OnboardingViewControllerWrapper()
                    VStack {
                        HStack {
                            Button("Cancel") {
                                isRoomCaptureViewPresented = false
                            }.buttonStyle(.automatic)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
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
    TopToolbarView(roomWidthText: .constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()), roomSceneViewModel: RoomSceneViewModel(roomSceneModel: RoomSceneModel(roomWidth: 0, roomHeight: 0, roomLength: 0)))
}
