//
//  ContentView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI
import SceneKit
import CoreData

struct RoundedCorners: View {
    var color: Color = .white
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height
                
                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
enum ProjectType {
    case new
    case existing(ProjectEntity) // Store the project entity for easy access.
}

struct ContentView: View {
    @StateObject var dataContentViewModel = ContentViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var routerView:RouterView
    
    @FetchRequest(entity: ProjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.projectName, ascending: true)])
    var newName: FetchedResults<ProjectEntity>
//    var projects: FetchedResults<ProjectEntity>
    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    @State private var currentProjectName: String = ""
    @State private var currentProjectEntity: ProjectEntity? = nil
    
    @StateObject var projectViewModel = ProjectViewModel()
    @State private var selectedProjectType: ProjectType? = nil
    @State private var fetchedScene: SCNScene? = nil
    
//    @Published var projectModel: ProjectModel
    
    var body: some View {
        NavigationStack(path: $routerView.path){
            
//        let a = projectViewModel.printAllData(in: viewContext)
            
            ScrollView{
                LazyVGrid(columns: columns) {
                    Button(action: {
                        selectedProjectType = .new
                        routerView.path.append("canvas")
                    }, label: {
                        RoundedRectangle(cornerRadius: 16, style: .circular)
                            .frame(width: 200, height: 200)
                            .shadow(radius: 5)
                            .foregroundColor(.white)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 130))
                                    .foregroundStyle(Color(hex: 0x326EEB))
                                    .fontWeight(.thin)
                            )
                    })
                    .padding(.bottom,30)
                    ForEach(newName){ newProjectName in
                        RoundedRectangle(cornerRadius: 16, style: .circular)
                            .frame(width: 200, height: 200)
                            .shadow(radius: 5)
                            .foregroundColor(.white)
                            .overlay(
                                ZStack {
                                    Image("project5")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(16)
                                    VStack(){
                                        Spacer()
                                        Text((newProjectName.projectName ?? "").prefix(10))
                                            .bold()
                                            .font(.title3)
                                            .padding(.vertical, 13)
                                            .padding(.leading, -75)
                                            .frame(maxWidth: .infinity)
                                            .background(RoundedCorners(bl:16, br:16))
                                    }
                                }
                            )
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Rename", systemImage: "pencil"){
                                    currentProjectName = newProjectName.projectName ?? ""
                                    currentProjectEntity = newProjectName
                                    dataContentViewModel.dataCanvas.isRenameAlertPresented = true
                                }
                                Button("Delete", systemImage: "trash", role: .destructive){
                                    dataContentViewModel.deleteProject(viewContext: viewContext, project: newProjectName)
                                }
                            }))
                            .onTapGesture {
                                selectedProjectType = .existing(newProjectName)
                                routerView.path.append("canvas")
                                //                            routerView.project = newProjectName
                                // routerView.uuid = newProjectName.projectID
                            }
                            .alert("Rename Project", isPresented: $dataContentViewModel.dataCanvas.isRenameAlertPresented) {
                                TextField("Enter a new project name", text: $currentProjectName)
                                Button("Cancel", role: .cancel) {
                                    dataContentViewModel.dataCanvas.isRenameAlertPresented = false
                                }
                                Button("Save") {
                                    // Handle renaming using the ViewModel
                                    dataContentViewModel.renameProject(project: currentProjectEntity!, newProjectName: currentProjectName, viewContext: viewContext)
                                    dataContentViewModel.dataCanvas.isRenameAlertPresented = false
                                }
                            }
                    }
                    
                    .padding(.bottom,30)
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("All Projects")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                    }
                }
            }
            .navigationDestination(for: String.self) { val in
                if val == "canvas"{
                    switch selectedProjectType {
                    case .new:
                        CanvasView(objectsButtonClicked: false, roomButtonClicked: false, viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false), existingProjectName: "")
                    case .existing(let selectedProject):
                        if let loadedScene = loadScene(for: selectedProject).0, let loadedSceneName = loadScene(for: selectedProject).1/*, let loadedSceneID = loadScene(for: selectedProject).1*/ {
                            CanvasView(objectsButtonClicked: false, roomButtonClicked: false, viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false), existingProjectName:  loadedSceneName/*, loadedSceneID: loadedSceneID*/)
                           } else {
                               // Handle the case where the scene couldn't be loaded, for instance:
                               Text("Failed to load project scene.")
                           }
                    case .none:
                        EmptyView()
                    }
                }else{
                    
                }
                
            }
        }
        
    }
    
    func loadScene(for project: ProjectEntity) -> (SCNScene?, String?/*, UUID?*/) {
        return projectViewModel.openSceneFromCoreData(userFilenmae: project.projectName ?? "", context: viewContext)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
        .environmentObject(RouterView())
}
