//
//  ArrowState.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/11/23.
//

//import Foundation
//import SceneKit

//class ArrowState {
//    var arrowX: SCNNode?
//    var arrowY: SCNNode?
//    var arrowZ: SCNNode?
//
//    func createArrows(parent: ScenekitView, axis: SCNVector3, color: UIColor, arrowName: String, X: Float, Y: Float, Z: Float) -> SCNNode{
//        let cylinder = SCNCylinder(radius: 0.01, height: 1.0)
//        cylinder.radialSegmentCount = 12
//        let cylinderMaterial = SCNMaterial()
//        cylinderMaterial.diffuse.contents = color
//        cylinderMaterial.transparency = 0
//        cylinder.firstMaterial = cylinderMaterial
//
//        let cone = SCNCone(topRadius: 0, bottomRadius: 0.07, height: 0.15)
//        cone.radialSegmentCount = 12
//        let coneMaterial = SCNMaterial()
//        coneMaterial.diffuse.contents = color
////            coneMaterial.transparency = 0.7
//        cone.firstMaterial = coneMaterial
//
//        let cylinderNode = SCNNode(geometry: cylinder)
//        let coneNode = SCNNode(geometry: cone)
//        coneNode.position = SCNVector3(0, 0.5, 0) // Adjust based on cylinder height
////            cylinderNode.addChildNode(coneNode)
//        
//        // Define the total height of the arrow for positioning the torus
//        let totalHeight = X / 2.0 // cylinder height + cone height
//        let torusRadius = X // Adjust as necessary
//       let torusThickness = 0.03 // Adjust as necessary
//
//       // Create the torus as the rotation indicator
//        let torus = SCNTorus(ringRadius: CGFloat(torusRadius), pipeRadius: torusThickness)
//        torus.firstMaterial?.diffuse.contents = color
//       let torusNode = SCNNode(geometry: torus)
//        torusNode.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, 0)
//       torusNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)// Lay the torus flat
//
//        
//        // Rotate the arrow according to the axis
//        if axis.x != 0 {
//            cylinderNode.eulerAngles = SCNVector3(CGFloat.pi / 2, 0, 0)
//            cylinderNode.name = "axisArrowX"
//            coneNode.eulerAngles = SCNVector3(CGFloat.pi / 2, 0, 0)
//            coneNode.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, X + 0.15)
//            coneNode.name = "axisArrowX"
//        } else if axis.y != 0 {
//            cylinderNode.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
//            cylinderNode.name = "axisArrowY"
//            coneNode.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
//            coneNode.position = SCNVector3(0, Y + 0.15, 0)
//            coneNode.name = "axisArrowY"
//        } else if axis.z != 0 {
//            cylinderNode.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
//            cylinderNode.name = "axisArrowZ"
//            coneNode.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
//            coneNode.position = SCNVector3(-0.15 - Z, Float(totalHeight) / 2 + 0.1, 0)
//            coneNode.name = "axisArrowZ"
//        }
//        
//        let parentNode = SCNNode()
////            parentNode.addChildNode(cylinderNode)
//        parentNode.addChildNode(coneNode)
//        parentNode.addChildNode(torusNode) // Add the torus node to the parent
//
//        // Set the name for both the cylinder and cone
//        cylinderNode.name = arrowName
//        coneNode.name = arrowName
//        torusNode.name = "axisArrowRotation" // Optionally, give the torus the same name
//
//        // Set the name for the parent node
//        parentNode.name = arrowName
//
//        return parentNode
//    }
//
//    func removeArrows() {
//        print("ARROW STATE - DESELECT START")
////        arrowX?.removeFromParentNode()
////        arrowY?.removeFromParentNode()
////        arrowZ?.removeFromParentNode()
//        
//        if let arrowX = arrowX {
//                arrowX.removeFromParentNode()
//                print("Removed arrowX")
//            } else {
//                print("arrowX is nil")
//            }
//            
//            if let arrowY = arrowY {
//                arrowY.removeFromParentNode()
//                print("Removed arrowY")
//            } else {
//                print("arrowY is nil")
//            }
//            
//            if let arrowZ = arrowZ {
//                arrowZ.removeFromParentNode()
//                print("Removed arrowZ")
//            } else {
//                print("arrowZ is nil")
//            }
//        
//
//        arrowX = nil
//        arrowY = nil
//        arrowZ = nil
//        
//        print("ARROW STATE - DESELECT END")
//    }
//
//    func updateArrows(node: SCNNode) {
//        // Make sure the arrows exist
//        guard let arrowX = self.arrowX, let arrowY = self.arrowY, let arrowZ = self.arrowZ else {
//            return
//        }
//        
//        let worldPosition = node.presentation.worldPosition // Use presentation for smooth updates
//        arrowX.worldPosition = worldPosition
//        arrowY.worldPosition = worldPosition
//        arrowZ.worldPosition = worldPosition
//    }
//}
