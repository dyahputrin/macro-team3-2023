//
//  RoomSceneViewModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import Foundation
import SceneKit

class RoomSceneViewModel: ObservableObject {
    @Published var customBoxNodes: [SCNNode] = []
        
    func addCustomBoxNode(_ node: SCNNode) {
        customBoxNodes.append(node)
    }
    
    func removeAllCustomBoxNodes() {
        customBoxNodes.removeAll()
    }
        
    // create the room
    func createCustomBox(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNNode {
        print("CREATE CUSTOM BOX")
        // Create the front, left, and right planes
        let frontPlane = SCNPlane(width: width, height: height)
        let leftPlane = SCNPlane(width: length, height: height)
        let rightPlane = SCNPlane(width: length, height: height)
        
        // Create nodes for the planes
        let frontNode = SCNNode(geometry: frontPlane)
        let leftNode = SCNNode(geometry: leftPlane)
        let rightNode = SCNNode(geometry: rightPlane)
        
        // Position the planes to create the illusion of a box with three sides missing
        frontNode.position = SCNVector3(0, 0, length / 2)
        leftNode.position = SCNVector3(-width / 2, 0, 0)
        rightNode.position = SCNVector3(width / 2, 0, 0)
        
        // Combine the nodes into a single node
        let customBoxNode = SCNNode()
        customBoxNode.addChildNode(frontNode)
        customBoxNode.addChildNode(leftNode)
        customBoxNode.addChildNode(rightNode)
        
        return customBoxNode
    }
    
}









