//
//  CanvasView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI
import SceneKit

struct CanvasView: View {
    private let viewContext = PersistenceController.shared.viewContext
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
    
    @StateObject private var roomSceneViewModel:CanvasDataViewModel
    @State private var sceneViewID = UUID()
    @State var roomWidthText: String = ""
    @State var roomLengthText: String = ""
    @State var roomHeightText: String = ""
    
    @State private var showSaveAlert = false
    @State private var newProjectName = ""
    @State private var renameClicked = false
    
    @State private var isRoomCaptureViewPresented = false
    @State private var isGuidedCaptureViewPresented = false
    
    @FetchRequest(entity: ProjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.projectName, ascending: true)])
    var projectEntity: FetchedResults<ProjectEntity>
    
    @Binding var activeProjectID: UUID
    @Binding var activeScene: SCNScene
    @State private var checkRename = false
    @State private var selectedAnObject = true
    @State private var showingObjectList = false
    @State private var objectSizeViewOffset: CGFloat = 0
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.2
    
    @ObservedObject var objectDimensionData: ObjectDimensionData = ObjectDimensionData()
    @State private var sceneBinding: Binding<SCNScene?> = .constant(nil)
    
    init(
        objectsButtonClicked: Bool,
        roomButtonClicked: Bool,
        povButtonClicked: Bool,
        viewfinderButtonClicked: Binding<Bool>,
        isImporting: Binding<Bool>,
        isExporting: Binding<Bool>,
        isSetButtonSidebarTapped: Binding<Bool>,
        activeProjectID: Binding<UUID>,
        activeScene: Binding<SCNScene>,
        projectData: ProjectData,
        routerView: RouterView
    ) {
        _objectsButtonClicked = State(initialValue: objectsButtonClicked)
        _roomButtonClicked = State(initialValue: roomButtonClicked)
        _povButtonClicked = State(initialValue: povButtonClicked)
        _viewfinderButtonClicked = viewfinderButtonClicked
        _isImporting = isImporting
        _isExporting = isExporting
        _isSetButtonSidebarTapped = isSetButtonSidebarTapped
        _activeProjectID = activeProjectID
        _activeScene = activeScene
        _roomSceneViewModel = StateObject(wrappedValue:CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: projectData, routerView: routerView))
    }
    
    @State private var currentScenekitView: ScenekitView? = nil
    @State private var snapshotImage: UIImage? = nil
    
    @State private var isEditMode: Bool = false
    @State private var roomWidth: Float = 0.0
    @State private var sceneRefreshToggle = false
    
    @State var coordinator: Coordinator?
    @State private var isViewVisible = true
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                let scenekitView =
                ScenekitView(
                    objectDimensionData: objectDimensionData,
                    scene: $roomSceneViewModel.rootScene,
                    isEditMode: $isEditMode,
                    roomWidth: $roomWidth, coordinator: $coordinator, isViewVisible: $isViewVisible
                )
                
                scenekitView
                    .edgesIgnoringSafeArea(.bottom)
                    .id(sceneViewID)
                    .onAppear {
                        currentScenekitView = scenekitView
//                        coordinator = Coordinator(currentScenekitView!)
//                        if coordinator != nil {
//                            coordinator?.deselectNodeAndArrows()
//                        }
                    }
            }
            
            if objectsButtonClicked == true {
                ObjectSidebarView(roomSceneViewModel: roomSceneViewModel)
                    .animation(.easeInOut(duration: 2), value: objectsButtonClicked)
                
            } else if roomButtonClicked == true {
                RoomSidebarView(roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText,  sceneViewID: $sceneViewID, activeProjectID: $activeProjectID, activeScene: $activeScene, roomSceneViewModel: roomSceneViewModel)
                    .animation(.easeInOut(duration: 2), value: roomButtonClicked)
            }
            
            ObjectListView(showingObjectList: $showingObjectList)
            //.animation(.easeInOut(duration: 0.3), value: showingObjectList)
            
            if objectDimensionData.name != "--" {
                ObjectSizeView(roomWidthText:.constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()), roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData(), routerView: RouterView()), objectDimensionData: objectDimensionData)
            }
            
        }
        .onAppear {
            roomButtonClicked = true
        }
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
                    
                    //EDIT MODE TOGGLE
                    Button(action : {
                        isEditMode.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(isEditMode ? .blue : .black)
                            .padding()
                    }
                    
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
                .padding(.vertical, 5)
                .padding(.trailing, 200)
            }
            
            // SAVE
            ToolbarItemGroup {
                
                Button(action: {
                    isSaveClicked = true
                    showSaveAlert = true
                    
                    roomSceneViewModel.saveProject(viewContext: viewContext)
                    
                    roomSceneViewModel.saveSnapshot(activeProjectID: activeProjectID, viewContext: viewContext, snapshotImageArg: snapshotImage, scenekitView: currentScenekitView!)
                    
                })
                {
                    VStack {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.black)
                        Text("Save")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 5)
                }.alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text("\(roomSceneViewModel.projectData.nameProject) Saved"),
                        dismissButton: .default(Text("OK")) {
                            if routerView.path.count > 0 {
                                routerView.path.removeLast()
                            }
                            isSaveClicked = true
                        }
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
                checkRename = true
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
                activeProjectID = routerView.project!.projectID!
                if let project = routerView.project,
                   let sceneData = project.projectScene {
                    do {
                        activeScene = try NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: sceneData)!
                    } catch {
                        print("Failed to unarchive SCN scene: \(error)")
                    }
                }
            }
            
            AppDelegate.orientationLock = .landscape // And making sure it stays that way
            
        }
        .onDisappear{
            coordinator?.deselectNodeAndArrows()
            print("CanvasView is disappearing")
            if routerView.path.count > 0 {
                routerView.path.removeLast()
            }
            roomSceneViewModel.projectData.nameProject = ""
            roomSceneViewModel.projectData.uuid = UUID()
            routerView.project = nil
        }
    }
}

