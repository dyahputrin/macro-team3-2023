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
    @State private var sheetPresented = true
    @State private var isSetButtonTapped = false
    @State var objectsButtonClicked: Bool
    @State var roomButtonClicked: Bool
    @State var povButtonClicked: Bool
    
//    @Binding var selectedURL: Data?
    
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
    
    @FetchRequest(entity: ProjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.projectName, ascending: true)])
    var projectEntity: FetchedResults<ProjectEntity>
    
    @Binding var activeProjectID: UUID
    @Binding var activeScene: SCNScene
    @State private var checkRename = false
    @State private var selectedAnObject = true
    @State private var showingObjectList = false
    
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
        activeScene: Binding<SCNScene>
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
    }
    
    @State private var currentScenekitView: ScenekitView? = nil
    @State private var snapshotImage: UIImage? = nil
    
    @State private var isEditMode: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            if routerView.project?.projectID == nil{
                ZStack {
                    let scenekitView = ScenekitView(objectDimensionData: objectDimensionData, scene: $roomSceneViewModel.rootScene, isEditMode: $isEditMode, roomWidth: Float(roomSceneViewModel.canvasData.roomWidth)
                    )
                    
                    scenekitView
                        .edgesIgnoringSafeArea(.bottom)
                        .id(sceneViewID)
                        .onAppear {
                            currentScenekitView = scenekitView
                        }
                    
                }
            }
            else {
                ZStack {
//                    let scenekitView = ScenekitView(objectDimensionData: objectDimensionData, scene: roomSceneViewModel.loadSceneFromCoreData(selectedProjectID: routerView.project!.projectID!, in: viewContext), isEditMode: $isEditMode, roomWidth: Float(routerView.project!.widthRoom))
                    let scenekitView = ScenekitView(
                        objectDimensionData: objectDimensionData,
                        scene: roomSceneViewModel.sceneBinding(),
                        isEditMode: $isEditMode,
                        roomWidth: Float(routerView.project!.widthRoom)
                    )
                    scenekitView
                        .edgesIgnoringSafeArea(.bottom)
                        .id(sceneViewID)
                        .onAppear {
                            currentScenekitView = scenekitView
                        }
                    
                }
            }
            
            if objectsButtonClicked == true {
                ObjectSidebarView(roomSceneViewModel:roomSceneViewModel)
                   
                    .animation(.easeInOut, value: objectsButtonClicked)
                
            } else if roomButtonClicked == true {
                RoomSidebarView(roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText,  sceneViewID: $sceneViewID, activeProjectID: $activeProjectID, activeScene: $activeScene, roomSceneViewModel: roomSceneViewModel)
                    //.transition(.moveAndFade)
                    .animation(.easeInOut, value: roomButtonClicked)
            }
            

            if objectDimensionData.name != "--" {
                ObjectSizeView(roomWidthText:.constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()), roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()), objectDimensionData: objectDimensionData)
            }
            
        }
        .toolbarRole(.editor)
        .toolbarBackground(Color.white)
        .toolbar {
            ToolbarItemGroup {
                HStack {
                    //POV TOP VIEW
                    Button(action: {
                        povButtonClicked.toggle()
                    })
                    {
                        Image(systemName: "light.panel")
                            .foregroundColor(povButtonClicked ? .accentColor :  .black)
                    }
                    .padding(.trailing)
                    
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
                    
                    //EDIT MODE TOGGLE
                    Button(action : {
                        isEditMode.toggle()
//                        objectsButtonClicked = false
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
                        Image(systemName: "square.split.bottomrightquarter")
                            .foregroundColor(roomButtonClicked ? .accentColor : .black)
                            .padding()
                    }
                    
                    //OBJECTS
                    Button(action : {
                        objectsButtonClicked.toggle()
                        roomButtonClicked = false
                    }) {
                        Image(systemName: "chair.lounge")
                            .foregroundColor(objectsButtonClicked ? .accentColor : .black)
                    }
                }
                .padding(.trailing, 100)
            }
            
            // UNDO & SAVE
            ToolbarItemGroup {

                Button(action: {
                    showSaveAlert = true
                    roomSceneViewModel.saveProject(viewContext: viewContext)

                    roomSceneViewModel.saveSnapshot(activeProjectID: activeProjectID, viewContext: viewContext, snapshotImageArg: snapshotImage, scenekitView: currentScenekitView!)
                    
                })
                {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.black)
                }.alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text("\(roomSceneViewModel.projectData.nameProject) Saved"),
                        dismissButton: .default(Text("OK")) {
                            if routerView.path.count > 0 {
                                routerView.path.removeLast()
                            }
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
        
        .navigationTitle(checkRename ? roomSceneViewModel.projectData.nameProject : (routerView.project == nil ? "NewProject" : roomSceneViewModel.projectData.nameProject))
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
                }            }
        }
        .onDisappear{

            
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

