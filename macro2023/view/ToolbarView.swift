////
////  ToolbarView.swift
////  macro2023
////
////  Created by Shalomeira Winata on 13/10/23.
////
//
//import SwiftUI
//
//struct ToolbarView: View {
//    @StateObject var toolbarData = AppState()
//    
//    @Binding var projectName: String
//    @Binding var roomButtonClicked: Bool
//    @Binding var objectsButtonClicked: Bool
//    @Binding var viewfinderButtonClicked: Bool
//    
//    var body: some View {
//        NavigationStack {
//            if roomButtonClicked {
//                RoomSidebarView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"), isSetButtonTapped: .constant(false))
//            } else if objectsButtonClicked {
//                ObjectSidebarView()
//            }
//        }
//        .navigationTitle(toolbarData.projectName)
//        .toolbar {
//            ToolbarItemGroup {
//                HStack {
//                    //VIEWFINDER
//                    Menu {
//                        Button(action: {}, label: {
//                            Text("Scan objects")
//                        })
//                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                            Text("Scan room")
//                        })
//                    } label: {
//                        Label("Viewfinder", systemImage: "viewfinder")
//                            .foregroundColor(.black)
//                    }
//                    
//                    // ROOM
//                    Button(action : {
//                        toolbarData.roomButtonClicked.toggle()
//                        toolbarData.objectsButtonClicked = false
//                    }) {
//                        Image(systemName: "square.split.bottomrightquarter")
//                            .foregroundColor(toolbarData.roomButtonClicked ? .blue : .black)
//                            .padding()
//                    }
//                    
//                    //OBJECTS
//                    Button(action : {
//                        toolbarData.objectsButtonClicked.toggle()
//                        toolbarData.roomButtonClicked = false
//                    }) {
//                        Image(systemName: "chair.lounge")
//                            .foregroundColor(toolbarData.objectsButtonClicked ? .blue : .black)
//                    }
//                }
//                .padding(.trailing, 100)
//            }
//            
//            // UNDO & SAVE
//            ToolbarItemGroup {
//                Button(action: {})
//                {
//                    Image(systemName: "arrow.uturn.backward.circle")
//                        .foregroundColor(.black)
//                        .padding()
//                }
//                Button(action: {})
//                {
//                    Image(systemName: "square.and.arrow.down")
//                        .foregroundColor(.black)
//                }
//            }
//        }
//        .toolbarTitleMenu {
//            Button(action: {
//                print("Action for context menu item 1")
//                //TextField("\(projectName)", text: $projectName)
//            }) {
//                Label("Rename", systemImage: "pencil")
//            }
//            Button(action: {
//                print("Action for context menu item 2")
//            }) {
//                Label("Export as USDZ", systemImage: "square.and.arrow.up")
//            }
//        }
//    }
//}
//
//#Preview {
//    ToolbarView(projectName: .constant("New Project"), roomButtonClicked: .constant(false), objectsButtonClicked: .constant(false), viewfinderButtonClicked: .constant(false))
//}
