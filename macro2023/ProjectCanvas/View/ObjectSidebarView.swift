//
//  ObjectSidebarView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI
import SceneKit

struct ObjectSidebarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var routerView: RouterView
    @StateObject private var ObjectVM = ObjectViewModel()
    
    @FetchRequest(entity: ObjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ObjectEntity.importedName, ascending: true)])
    var importsObject: FetchedResults<ObjectEntity>
    
    @State private var currentSection = "Objects"
    @State var thumbnailPreview : Image?
    @State var isShowingScene: Bool = false
    var section = ["Objects", "Imports"]
    
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
                            
                            if currentSection == "Objects" {
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 30) {
                                        
                                        ForEach(1..<15, id: \.self) { index in
                                            Image(systemName: "plus.app.fill")
                                                .frame(width: 100, height: 100)
                                                .font(.system(size: 100))
                                                .shadow(radius: 5)
                                        }
                                    }
                                    .padding(.vertical)
                                }
                            } else if currentSection == "Imports" {
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 30) {
                                        
                                        Button(action: {
                                            ObjectVM.presentDocumentPicker()
                                        }, label: {
                                            Image(systemName: "plus")
                                                .foregroundStyle(Color(hex: 0x28B0E5))
                                                .font(.system(size: 50))
                                        })
                                        ForEach(importsObject){ urlImport in
                                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                                .shadow(radius:5)
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.white)
                                                .overlay{
                                                    VStack {
                                                        if let thumbnailData = urlImport.importedPreview,
                                                           let thumbnailImage = UIImage(data: thumbnailData) {
                                                            Image(uiImage: thumbnailImage)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 100, height: 100)
                                                        } else {
                                                            Image("OfficeTable")
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 100, height: 100)
                                                        }
                                                        Text("\(urlImport.importedName ?? "error")")
                                                        if let importedObject = urlImport.importedURL, let scene = ObjectVM.CoreStringScene(URLName: importedObject) {
                                                            SceneView(scene: scene)
                                                                .frame(width: 800, height: 800)
                                                                .background(Color.red)
                                                        } else {
                                                            Text("Failed to load the USDZ file.")
                                                        }
                                                    }
                                                }
                                        }
                                        
                                    }
                                    .padding(.top)
                                }
                            }
                        }
                            .padding()
                            .background(Color.systemGray6)
                    )
//                    .frame(width: geometry.size.width * 0.3)
                    .padding(.top, 10)
                
            }
            
        }
    }
}

#Preview {
    ObjectSidebarView().environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
        .environmentObject(RouterView())
}

