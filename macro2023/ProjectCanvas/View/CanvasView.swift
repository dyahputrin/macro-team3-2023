//
//  CanvasView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI
import SceneKit

struct CanvasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var routerView: RouterView
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showBackAlert = false
    @State private var isSaveClicked = false
    @State private var isProjectSaved = false
    
    @State private var sheetPresented = true
    @State private var isSetButtonTapped = false
    @State var objectsButtonClicked: Bool
    @State var roomButtonClicked: Bool
    @State var povButtonClicked: Bool
    
    @Binding var viewfinderButtonClicked: Bool
    @Binding var isImporting: Bool
    @Binding var isExporting: Bool
    @Binding var isSetButtonSidebarTapped: Bool
    
    @StateObject private var roomSceneViewModel = CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData())
    @State private var sceneViewID = UUID()
    @State var roomWidthText: String = ""
    @State var roomLengthText: String = ""
    @State var roomHeightText: String = ""
    
    @State private var showSaveAlert = false
    @State private var newProjectName = ""
    @State private var renameClicked = false
    
    @State private var isRoomCaptureViewPresented = false
    @State private var isGuidedCaptureViewPresented = false
    
    @State private var selectedAnObject = true
    @State private var showingObjectList = false
    @State private var objectSizeViewOffset: CGFloat = 0
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.2
    
    var body: some View {
        
        GeometryReader { geometry in
            if routerView.project?.projectID == nil{
                ZStack {
                    let _ = print(routerView.project?.projectID)
                    SceneView(scene: roomSceneViewModel.makeScene(width: roomSceneViewModel.canvasData.roomWidth, height: roomSceneViewModel.canvasData.roomHeight, length: roomSceneViewModel.canvasData.roomLength), options: [.allowsCameraControl])
                        .edgesIgnoringSafeArea(.bottom)
                        .id(sceneViewID)
                }
            }
            else {
                ZStack {
                    SceneView(scene: roomSceneViewModel.loadSceneFromCoreData(selectedProjectID: routerView.project!.projectID!, in: viewContext), options: [.allowsCameraControl])
                        .edgesIgnoringSafeArea(.bottom)
                        .id(sceneViewID)
                }
            }
            
            if objectsButtonClicked == true {
                ObjectSidebarView()
                    .animation(.easeInOut(duration: 0.5), value: objectsButtonClicked)
                
            } else if roomButtonClicked == true {
                RoomSidebarView(roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText,  sceneViewID: $sceneViewID, roomSceneViewModel: roomSceneViewModel)
                    .animation(.easeInOut(duration: 2), value: roomButtonClicked)
            }
            
            ObjectListView(showingObjectList: $showingObjectList)
                //.animation(.easeInOut(duration: 0.3), value: showingObjectList)
            
            if selectedAnObject == true {
                ObjectSizeView(roomWidthText:.constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()) ,roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()))
                    .offset(x: objectSizeViewOffset)
                    .animation(.easeInOut(duration: 0.5), value: showingObjectList)
                    .padding(.leading, showingObjectList ? (sideBarWidth + 10) : 0)
            }
        }
        .onAppear {
            roomButtonClicked = true
        }
        //        .sheet(isPresented: $sheetPresented) {
        //            SizePopUpView(sheetPresented: $sheetPresented, isSetButtonTapped: $isSetButtonTapped, roomSceneViewModel: roomSceneViewModel, sceneViewID: $sceneViewID, roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText)
        //                .interactiveDismissDisabled()
        //        }
        .toolbarRole(.editor)
        .toolbarBackground(Color.white)
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
                            Text("Scan")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding(.trailing, 50)
                    
                    // ROOM
                    Button(action : {
                        roomButtonClicked.toggle()
                        objectsButtonClicked = false
                    }) {
                        VStack {
                            Image(systemName: "square.split.bottomrightquarter")
                                .foregroundColor(roomButtonClicked ? .accentColor : .black)
                            Text("Room")
                                .font(.subheadline)
                                .foregroundColor(roomButtonClicked ? .accentColor : .black)
                        }
                    }
                    
                    //OBJECTS
                    Button(action : {
                        objectsButtonClicked.toggle()
                        roomButtonClicked = false
                    }) {
                        VStack {
                            Image(systemName: "chair.lounge")
                                .foregroundColor(objectsButtonClicked ? .accentColor : .black)
                            Text("Objects")
                                .font(.subheadline)
                                .foregroundColor(objectsButtonClicked ? .accentColor : .black)
                        }
                    }

                }
                .padding(.trailing, 200)
            }
            
            // SAVE
            ToolbarItemGroup {
                Button(action: {
                    isSaveClicked = true
                    showSaveAlert = true
                    roomSceneViewModel.saveProject(viewContext: viewContext)
                })
                {
                    VStack {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.black)
                        Text("Save")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }.alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text("\(roomSceneViewModel.projectData.nameProject) Saved"),
                        dismissButton: .default(Text("OK"), action: {
                            isSaveClicked = true
                        })
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
//        .fullScreenCover(isPresented: $isGuidedCaptureViewPresented, content: {
//            GuidedCaptureView()
//        })
        .navigationTitle(routerView.project == nil ? "NewProject" : roomSceneViewModel.projectData.nameProject)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            if !isSaveClicked {
                showBackAlert = true
            } else if isSaveClicked || isProjectSaved {
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            Image(systemName: "chevron.left")
        }).alert(isPresented: $showBackAlert) {
            Alert(
                title: Text("Save Project"),
                message: Text("Do you want to save changes before leaving?"),
                primaryButton: .default(Text("Save"), action: {
                    roomSceneViewModel.saveProject(viewContext: viewContext)
                    showSaveAlert = true
                }),
                secondaryButton: .destructive(Text("No"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
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
            TextField("\(roomSceneViewModel.projectData.nameProject)", text: $newProjectName)
            Button("Save", action: {
                roomSceneViewModel.projectData.nameProject = newProjectName
                renameClicked = false
            })
            Button("Cancel", role: .cancel, action: {
                renameClicked = false
            })
        })
        .onAppear{
            if routerView.project != nil{
                roomSceneViewModel.projectData.nameProject = routerView.project!.projectName!
                roomSceneViewModel.projectData.uuid = routerView.project!.projectID!
            }
        }
        .onDisappear{
            if routerView.path.count > 0 {
                routerView.path.removeLast()
            }
            roomSceneViewModel.projectData.nameProject = ""
            roomSceneViewModel.projectData.uuid = UUID()
            routerView.project = nil
        }
        
    }
}



#Preview {
    CanvasView(objectsButtonClicked: false, roomButtonClicked: false, povButtonClicked: false, viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false)).environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
        .environmentObject(RouterView())
}
