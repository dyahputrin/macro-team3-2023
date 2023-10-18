//
//  CanvasView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI

struct CanvasView: View {
    @State private var sheetPresented = true
    @State private var isSetButtonTapped = false
    @State var objectsButtonClicked: Bool
    @State var roomButtonClicked: Bool
    
    @Binding var viewfinderButtonClicked: Bool
    @Binding var isImporting: Bool
    @Binding var isExporting: Bool
    @Binding var isSetButtonSidebarTapped: Bool
    
    @StateObject private var roomSceneViewModel = RoomSceneViewModel(roomSceneModel: RoomSceneModel(roomWidth: 0, roomHeight: 0, roomLength: 0))
    @State private var sceneViewID = UUID()
    @State var roomWidthText: String = ""
    @State var roomLengthText: String = ""
    @State var roomHeightText: String = ""
    
    @State private var showSaveAlert = false
    @State private var projectName = "New Project"
    @State private var newProjectName = ""
    @State private var renameClicked = false
    
    @State private var isRoomCaptureViewPresented = false
    @State private var isGuidedCaptureViewPresented = false
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                RoomSceneView(roomSceneViewModel: roomSceneViewModel, sceneViewID: $sceneViewID)
            }
            
            if objectsButtonClicked == true {
                ObjectSidebarView()
                    .transition(.moveAndFade)
                
            } else if roomButtonClicked == true {
                RoomSidebarView(roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText,  sceneViewID: $sceneViewID, roomSceneViewModel: roomSceneViewModel)
                    .transition(.moveAndFade)
            }
        }
        .onAppear {
            sheetPresented = true
        }
//        .sheet(isPresented: $sheetPresented) {
//            SizePopUpView(sheetPresented: $sheetPresented, isSetButtonTapped: $isSetButtonTapped, roomSceneViewModel: roomSceneViewModel, sceneViewID: $sceneViewID, roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText)
//                .interactiveDismissDisabled()
//        }
        .toolbarRole(.editor)
        .toolbarBackground(Color.blue)
        .toolbar {
            ToolbarItemGroup {
                HStack {
                    //VIEWFINDER
                    Menu {
                        Button(action: {
                            self.isGuidedCaptureViewPresented = true
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
        // ROOM PLAN
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
        .fullScreenCover(isPresented: $isGuidedCaptureViewPresented, content: {
            GuidedCaptureView()
        })
        .navigationTitle(projectName)
        .toolbarTitleMenu {
            Button(action: {
                renameClicked = true
                print("Action for context menu item 1")
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
    CanvasView(objectsButtonClicked: false, roomButtonClicked: false, viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false))
}
