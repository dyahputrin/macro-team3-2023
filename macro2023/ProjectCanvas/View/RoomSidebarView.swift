//
//  RoomSidebarView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI
import SceneKit

struct RoomSidebarView: View {
    
    @State private var isSetButtonSidebarTapped = false
    
    @State private var currentSection = "Room Size"
    var section = ["Room Size", "Imports"]
    
    @Binding var roomWidthText: String
    @Binding var roomLengthText: String
    @Binding var roomHeightText: String
    @Binding var sceneViewID: UUID
    @Binding var activeProjectID: UUID
    @Binding var activeScene: SCNScene
    var roomSceneViewModel: CanvasDataViewModel
    @StateObject private var RoomVM = RoomPlanViewModel()
    @State private var sceneKitView: ThumbnailView?
    
    @FetchRequest(entity: RoomPlanEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \RoomPlanEntity.roomPlanName, ascending: true)])
    var roomPlans: FetchedResults<RoomPlanEntity>
    
    private let viewContext = PersistenceController.shared.viewContext
    @EnvironmentObject var routerView: RouterView
    @FetchRequest(entity: ProjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.projectName, ascending: true)])
    var projectEntity: FetchedResults<ProjectEntity>
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        GeometryReader { geometry in
            HStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color.systemGray6)
                    .overlay (
                        VStack {
                            Picker("", selection: $currentSection) {
                                ForEach(section, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            if currentSection == "Room Size" {
                                GeometryReader { geometry in
                                    VStack(alignment: .leading) {
                                        Text("Width").bold()
                                        HStack {
                                            TextField("min. 2", text:$roomWidthText)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        .padding(.bottom)
                                        
                                        Text("Length").bold()
                                        HStack {
                                            TextField("min. 2", text: $roomLengthText)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        .padding(.bottom)
                                        
                                        
                                        Text("Wall Height").bold()
                                        HStack {
                                            TextField("min. 2", text: $roomHeightText)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                            Text("m")
                                        }
                                        
                                        Button(action: {
                                            isSetButtonSidebarTapped = true
                                            if let width = roomSceneViewModel.stringToCGFloat(value: roomWidthText),
                                               let height = roomSceneViewModel.stringToCGFloat(value: roomHeightText),
                                               let length = roomSceneViewModel.stringToCGFloat(value: roomLengthText) {
                                                
                                                if let project = routerView.project,
                                                   let sceneData = project.projectScene {
                                                    do {
                                                        activeScene = try NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: sceneData)!
                                                    } catch {
                                                        print("Failed to unarchive SCN scene: \(error)")
                                                    }
                                                }
                                                roomSceneViewModel.updateRoomSize(newWidth: width, newHeight: height, newLength: length, activeProjectID: activeProjectID, viewContext: viewContext)
                                                sceneViewID = UUID()
                                            } else {
                                                // Handle invalid input
                                            }
                                            
                                        }) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.07)
                                            
                                                .overlay {
                                                    Text("Set")
                                                        .font(.title3).bold()
                                                        .foregroundColor(.white)
                                                }
                                        }
                                        .padding(.top, 30)
                                    }
                                    .padding()
                                }
                                
                            } else if currentSection == "Imports" {
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 30) {
                                        
                                        Button(action: {
                                            RoomVM.presentDocumentPicker()
                                        }, label: {
                                            Image(systemName: "plus")
                                                .foregroundStyle(Color(hex: 0x28B0E5))
                                                .font(.system(size: 50))
                                                .frame(width: 100, height: 100)
                                        })
                                        ForEach(roomPlans, id: \.self){ importedRoomPlan in
                                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                                .shadow(radius:5)
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.clear)
                                                .overlay{
                                                    VStack {
                                                        if let usdzData = importedRoomPlan.roomPlanObject {
                                                            ThumbnailView(usdzData: usdzData)
                                                                .frame(width: 100, height: 100)
                                                                .cornerRadius(25)
                                                                .shadow(radius: 5)
                                                                .onTapGesture {
                                                                    roomSceneViewModel.addImportObjectChild(data: usdzData)
                                                                }
                                                        }
                                                        Text("\(importedRoomPlan.roomPlanName ?? "error")")
                                                    }
                                                }
                                        }
                                        
                                    }
                                    .padding(.top)
                                }
                            }
                            
                        }
                            .padding()
                            //.background(Color.systemGray6)
                            .background(.regularMaterial)
                    )
                    .frame(width: geometry.size.width * 0.3)
                    .padding(.top, 1)
                
            }
            
        }
    }
}


//#Preview {
//    RoomSidebarView(roomWidthText:.constant("2"), roomLengthText: .constant("2"), roomHeightText: .constant("2"), sceneViewID: .constant(UUID()), activeProjectID: .constant(UUID()), activeScene: .constant(SCNScene()), roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()))
//}
