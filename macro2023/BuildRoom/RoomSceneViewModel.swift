//
//  RoomSceneViewModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import Foundation
import SceneKit

class RoomSceneViewModel: ObservableObject {
    @Published var roomSceneModel: RoomSceneModel = RoomSceneModel(roomWidth: 2, roomHeight: 2, roomLength: 2)
    
//    init(roomSceneModel: RoomSceneModel) {
//        self.roomSceneModel = roomSceneModel
//    }
    
    func makeScene(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNScene? {
//        roomSceneModel.scene = SCNScene(named: "RoomScene.scn")!
//        let scene = roomSceneModel.scene
        let scene = SCNScene(named: "RoomScene.scn")
        let floorNode = SCNNode()
        let wall1Node = SCNNode()
        let wall2Node = SCNNode()
        let tableNode = SCNNode()
        
        if let floorAsset = SCNScene(named: "v2floor.usdz"){
            let floorGeometry = floorAsset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            floorNode.geometry = floorGeometry
//            floorNode.scale = SCNVector3(width, height, length)
            floorNode.scale = SCNVector3(roomSceneModel.roomWidth, roomSceneModel.roomHeight, roomSceneModel.roomLength)
            floorNode.addChildNode(floorAsset.rootNode)
            scene?.rootNode.addChildNode(floorNode)
        }
        if let wall1Asset = SCNScene(named: "v2wall1.usdz"){
            let wall1Geometry = wall1Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall1Node.geometry = wall1Geometry
//            wall1Node.scale = SCNVector3(width, height, length)
            wall1Node.position = SCNVector3()
            wall1Node.scale = SCNVector3(roomSceneModel.roomWidth, roomSceneModel.roomHeight, roomSceneModel.roomLength)
            wall1Node.addChildNode(wall1Asset.rootNode)
            scene?.rootNode.addChildNode(wall1Node)
        }
        if let wall2Asset = SCNScene(named: "v2wall2.usdz"){
            let wall2Geometry = wall2Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall2Node.geometry = wall2Geometry
//            wall2Node.scale = SCNVector3(width, height, length)
            wall2Node.scale = SCNVector3(roomSceneModel.roomWidth, roomSceneModel.roomHeight, roomSceneModel.roomLength)
            wall2Node.addChildNode(wall2Asset.rootNode)
            scene?.rootNode.addChildNode(wall2Node)
        }
        if let tableAsset = SCNScene(named: "OfficeTable.usdz"){
            let tableGeometry = tableAsset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            tableNode.geometry = tableGeometry
            tableNode.addChildNode(tableAsset.rootNode)
            scene?.rootNode.addChildNode(tableNode)
        }
        
        return scene
    }
    
    func updateRoomSize(width: CGFloat, height: CGFloat, length: CGFloat) {
        roomSceneModel.roomWidth = width
        roomSceneModel.roomHeight = height
        roomSceneModel.roomLength = length
        print("Update Room Size --> width: \(roomSceneModel.roomWidth); height: \(roomSceneModel.roomHeight); length: \(roomSceneModel.roomLength)")
    }
    
    func stringToCGFloat(value: String) -> CGFloat? {
        if let floatValue = Float(value) {
            return CGFloat(floatValue)
        }
        return nil
    }
    
}









