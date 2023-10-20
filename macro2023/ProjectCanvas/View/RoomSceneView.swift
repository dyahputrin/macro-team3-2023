//
//  RoomSceneView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import SwiftUI
import SceneKit

struct RoomSceneView: View {
    var roomSceneViewModel: CanvasDataViewModel
    @Binding var sceneViewID: UUID
    
    var body: some View {
        VStack {
            SceneView(scene: roomSceneViewModel.makeScene(width: roomSceneViewModel.canvasData.roomWidth, height: roomSceneViewModel.canvasData.roomHeight, length: roomSceneViewModel.canvasData.roomLength), options: [.allowsCameraControl])
                .edgesIgnoringSafeArea(.bottom)
                .id(sceneViewID)
        }
    }
}

#Preview {
    RoomSceneView(roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()), sceneViewID: .constant(UUID()))
}
