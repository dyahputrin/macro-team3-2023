//
//  RoomSceneView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import SwiftUI
import SceneKit

struct RoomSceneView: View {
    
    @ObservedObject var roomSceneViewModel: RoomSceneViewModel
    var roomSceneModel: RoomSceneModel
    @State private var sceneViewID = UUID()
    
    init() {
        let roomSceneModel = RoomSceneModel(roomWidth: 2, roomHeight: 2, roomLength: 2)
        self.roomSceneModel = roomSceneModel
        self.roomSceneViewModel = RoomSceneViewModel()
    }
    
    var body: some View {
        VStack {
            SceneView(scene: roomSceneViewModel.makeScene(width: roomSceneModel.roomWidth, height: roomSceneModel.roomHeight, length: roomSceneModel.roomLength), options: [.allowsCameraControl])
                .edgesIgnoringSafeArea(.all)
                .id(sceneViewID)
                
            HStack {
                TextField("Room Length", text: $roomSceneViewModel.roomSceneModel.roomLengthText)
                    .padding(10)
                    .border(Color.gray, width: 1)
                TextField("Room Width", text: $roomSceneViewModel.roomSceneModel.roomWidthText)
                    .padding(10)
                    .border(Color.gray, width: 1)
                TextField("Room Height", text: $roomSceneViewModel.roomSceneModel.roomHeightText)
                    .padding(10)
                    .border(Color.gray, width: 1)
                Button(action: {
                    if let width = roomSceneViewModel.stringToCGFloat(value: roomSceneViewModel.roomSceneModel.roomWidthText),
                       let height = roomSceneViewModel.stringToCGFloat(value: roomSceneViewModel.roomSceneModel.roomHeightText),
                       let length = roomSceneViewModel.stringToCGFloat(value: roomSceneViewModel.roomSceneModel.roomLengthText) {
                        roomSceneViewModel.updateRoomSize(width: width, height: height, length: length)
                        sceneViewID = UUID() 
                    } else {
                        // Handle invalid input
                    }
                }) {
                    Text("Set")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            
        }
    }
}

#Preview {
    RoomSceneView()
}
