//
//  RoomSceneView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import SwiftUI
import SceneKit
import CoreData

struct RoomSceneView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var roomSceneViewModel: RoomSceneViewModel
//    var projectViewModel: ProjectViewModel
    @Binding var sceneViewID: UUID
    var loadedScene: SCNScene?
//    var loadedSceneID: UUID?
    
    var body: some View {
        VStack {
            SceneView(scene: roomSceneViewModel.makeScene(width: roomSceneViewModel.roomSceneModel.roomWidth, height: roomSceneViewModel.roomSceneModel.roomHeight, length: roomSceneViewModel.roomSceneModel.roomLength), options: [.allowsCameraControl])
                .edgesIgnoringSafeArea(.bottom)
                .id(sceneViewID)
        }
    }
}

#Preview {
    RoomSceneView(roomSceneViewModel: RoomSceneViewModel(roomSceneModel: RoomSceneModel(roomWidth: 0, roomHeight: 0, roomLength: 0)), sceneViewID: .constant(UUID()))
}
