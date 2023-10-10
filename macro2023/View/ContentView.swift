//
//  ContentView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: ProjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.projectName, ascending: true)])
    var newName: FetchedResults<ProjectEntity>

    
    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns) {
                    NavigationLink(destination:CanvasView()
                                   ,label: {
                        VStack{
                            Image(systemName: "plus")
                                .frame(width:100, height: 100)
                                .border(Color.black)
                            Text("New Project")
                                .foregroundColor(.black)
                        }
                    })
                    .padding()
                    ForEach(newName){ newProjectName in
                        NavigationLink(destination:CanvasView()
                                       ,label: {
                            VStack{
                                Image(systemName: "plus")
                                    .frame(width:100, height: 100)
                                    .border(Color.black)
                                Text(newProjectName.projectName ?? "")
                                    .foregroundColor(.black)
                            }
                        })
                        .padding()
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("All Project")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
}
