//
//  RoomSceneView.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import SwiftUI
import SceneKit

struct RoomSceneView: View {
    static func makeScene() -> SCNScene? {
        let scene = SCNScene(named: "RoomScene.scn")
        return scene
    }
    
    @ObservedObject var roomSceneViewModel = RoomSceneViewModel()
    @GestureState private var dragOffset: CGSize = .zero
    var scene = makeScene()
    @State private var roomLength: String = ""
    @State private var roomWidth: String = ""
    @State private var roomHeight: String = ""
    
    var cameraNode: SCNNode? {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        return cameraNode
    }
    
    var body: some View {
        VStack {
            SceneView(scene: scene, options: [.allowsCameraControl])
                .edgesIgnoringSafeArea(.all)
            HStack {
                TextField("Room Length", text: $roomLength)
                    .padding(10)
                    .border(Color.gray, width: 1)
                TextField("Room Width", text: $roomWidth)
                    .padding(10)
                    .border(Color.gray, width: 1)
                TextField("Room Height", text: $roomHeight)
                    .padding(10)
                    .border(Color.gray, width: 1)
            }
        }
        
    }
}

#Preview {
    RoomSceneView()
}
