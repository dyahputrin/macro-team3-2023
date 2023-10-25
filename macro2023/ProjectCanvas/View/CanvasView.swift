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
    
    var body: some View {
        
        GeometryReader { geometry in
            if routerView.project?.projectID == nil{
                ZStack {
                    let sceneKitView = ScenekitView(scene: roomSceneViewModel.makeScene(width: roomSceneViewModel.canvasData.roomWidth, height: roomSceneViewModel.canvasData.roomHeight, length: roomSceneViewModel.canvasData.roomLength)!)
                   
                    sceneKitView
                        .edgesIgnoringSafeArea(.bottom)
                        .id(sceneViewID)
                }
            }
            else {
                ZStack {
                    let sceneKitView = ScenekitView(scene: roomSceneViewModel.loadSceneFromCoreData(selectedProjectID: routerView.project!.projectID!, in: viewContext)!)
                   
                    sceneKitView
                        .edgesIgnoringSafeArea(.bottom)
                        .id(sceneViewID)
                }
            }
            
            if objectsButtonClicked == true {
                ObjectSidebarView()
                    .transition(.moveAndFade)
                
            } else if roomButtonClicked == true {
                RoomSidebarView(roomWidthText: $roomWidthText, roomLengthText: $roomLengthText, roomHeightText: $roomHeightText,  sceneViewID: $sceneViewID, activeProjectID: $activeProjectID, activeScene: $activeScene, roomSceneViewModel: roomSceneViewModel)
                    .transition(.moveAndFade)
            }
        }
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
                    roomSceneViewModel.saveProject(viewContext: viewContext)
                })
                {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.black)
                }.alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text("\(roomSceneViewModel.projectData.nameProject) Saved"),
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
//        .fullScreenCover(isPresented: $isGuidedCaptureViewPresented, content: {
//            GuidedCaptureView()
//        })
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
    CanvasView(objectsButtonClicked: false, roomButtonClicked: false, viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false))
        .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
            .environmentObject(RouterView())
}
