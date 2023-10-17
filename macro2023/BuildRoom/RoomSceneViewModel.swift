//
//  RoomSceneViewModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import Foundation
import SceneKit

class RoomSceneViewModel: ObservableObject {
    
    @Published var roomSceneModel: RoomSceneModel
    init(roomSceneModel: RoomSceneModel) {
        self.roomSceneModel = roomSceneModel
    }
    
    // function to make the scene
    func makeScene(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNScene? {
        print("MAKE SCENE")
        let scene = SCNScene(named: "RoomScene.scn")
        let floorNode = SCNNode()
        let wall1Node = SCNNode()
        let wall2Node = SCNNode()
        
        scene?.background.contents = UIColor.lightGray
        
        if let floorAsset = SCNScene(named: "v2floor.usdz"){
            let floorGeometry = floorAsset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            floorNode.geometry = floorGeometry
            floorNode.scale = SCNVector3(roomSceneModel.roomWidth, roomSceneModel.roomHeight, roomSceneModel.roomLength)
            floorNode.addChildNode(floorAsset.rootNode)
            scene?.rootNode.addChildNode(floorNode)
        }
        if let wall1Asset = SCNScene(named: "v2wall1.usdz"){
            let wall1Geometry = wall1Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall1Node.geometry = wall1Geometry
            wall1Node.position = SCNVector3()
            wall1Node.scale = SCNVector3(roomSceneModel.roomWidth, roomSceneModel.roomHeight, roomSceneModel.roomLength)
            wall1Node.addChildNode(wall1Asset.rootNode)
            scene?.rootNode.addChildNode(wall1Node)
        }
        if let wall2Asset = SCNScene(named: "v2wall2.usdz"){
            let wall2Geometry = wall2Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall2Node.geometry = wall2Geometry
            wall2Node.scale = SCNVector3(roomSceneModel.roomWidth, roomSceneModel.roomHeight, roomSceneModel.roomLength)
            wall2Node.addChildNode(wall2Asset.rootNode)
            scene?.rootNode.addChildNode(wall2Node)
        }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        // Set the custom position for the camera using SCNVector3
        let customCameraPosition = SCNVector3(x: 0, y: 5, z: 5)
        cameraNode.position = customCameraPosition
        scene?.rootNode.addChildNode(cameraNode)
        
        return scene
    }
    
    // function for updating room size
    func updateRoomSize(width: CGFloat, height: CGFloat, length: CGFloat) {
        roomSceneModel.roomWidth = width
        roomSceneModel.roomHeight = height
        roomSceneModel.roomLength = length
        print("Update Room Size --> width: \(roomSceneModel.roomWidth); height: \(roomSceneModel.roomHeight); length: \(roomSceneModel.roomLength)")
    }
    
    // function for convert text to cgfloat for room size
    func stringToCGFloat(value: String) -> CGFloat? {
        if let floatValue = Float(value) {
            return CGFloat(floatValue)
        }
        return nil
    }
    
}









