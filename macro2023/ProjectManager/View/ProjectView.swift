//
//  ContentView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI
import SceneKit

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

struct ProjectView: View {
    @StateObject var dataContentViewModel = ProjectViewModel()

    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var routerView:RouterView

    @FetchRequest(entity: ProjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.projectName, ascending: true)])
    var recentlyOpenedItems: FetchedResults<ProjectEntity>

    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]

    @State private var currentProjectName: String = ""

    @State private var currentProjectEntity: ProjectEntity? = nil
    
    @State var activeProjectID: UUID
    @State var activeScene: SCNScene

    var body: some View {
//        let _ = dataContentViewModel.printAllData(in: viewContext)
        NavigationStack(path: $routerView.path){
            ScrollView{
                LazyVGrid(columns: columns) {
                    Button(action: {
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
                    ForEach(recentlyOpenedItems){ newProjectName in
                        RoundedRectangle(cornerRadius: 16, style: .circular)
                            .frame(width: 200, height: 200)
                            .shadow(radius: 5)
                            .foregroundColor(.white)
                            .overlay(
                                ZStack {
                                    var thumbnailImage: UIImage {
                                            if let thumbnailData = newProjectName.projectThumbnail,
                                               let image = UIImage(data: thumbnailData) {
                                                return image
                                            } else {
                                                return UIImage(named: "project5") ?? UIImage() // Provide a fallback default image
                                            }
                                        }
//                                    Image(uiImage: UIImage(data: newProjectName.projectThumbnail ?? UIImage(named: "project5"))!)
                                    Image(uiImage: thumbnailImage)
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
                                let _ = print(newProjectName.projectScene)
                                dataContentViewModel.deleteProject(viewContext: viewContext, project: newProjectName)
                            }
                        }))
                        .onTapGesture {
                            routerView.path.append("canvas")
                            routerView.project = newProjectName
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
                    CanvasView(objectsButtonClicked: false, roomButtonClicked: false, viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false), activeProjectID: $activeProjectID, activeScene: $activeScene)
                }else{

                }

            }
        }

    }
}

#Preview {
    ProjectView(activeProjectID: UUID(), activeScene: SCNScene()).environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
        .environmentObject(RouterView())
}

