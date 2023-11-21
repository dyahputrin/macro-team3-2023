//
//  Coordinator.swift
//  macro2023
//
//  Created by Billy Jefferson on 17/11/23.
//

import Foundation
import SwiftUI
import SceneKit

class Coordinator: NSObject, UIGestureRecognizerDelegate {
    var parent: ScenekitView
    private var selectedNode: SCNNode?
    private var lastPanTranslation: CGPoint = .zero
    @State private var objectDimensionData: ObjectDimensionData
    var selectedAxis: String?
    var arrowX: SCNNode?
    var arrowY: SCNNode?
    var arrowZ: SCNNode?
    var tappedNode : SCNNode?
    
    init(_ parent: ScenekitView) {
        self.parent = parent
        self.objectDimensionData = parent.objectDimensionData
        super.init()
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let p = gestureRecognizer.location(in: parent.view)
        let hitResults = parent.view.hitTest(p, options: [:])
        
        if hitResults.count == 0 || hitResults.first!.node.name == nil || tappedNode == hitResults.first!.node {
            parent.isEditMode = false
            objectDimensionData.reset()
            deselectNodeAndArrows()
            tappedNode = nil
            dicek = true
            return
        } else {
            let removeValue = hitResults.first?.node
            parent.isEditMode = true
            objectDimensionData.selectedChildNode = removeValue!
            selectedNode?.childNodes.forEach { node in
                if node.name?.hasPrefix("axisArrow") == true {
                    node.opacity = 0.3
                }
            }
            
            if let result = hitResults.first(where: { $0.node.name?.hasPrefix("axisArrow") == true }) {
                // Set the tapped arrow's opacity to 1.0
                result.node.opacity = 1.0
                result.node.parent?.opacity = 1.0
                selectedAxis = result.node.name
                addPanGesture()
            } else if let result = hitResults.first {
                processNodeSelection(result.node)
                selectedAxis = nil
                tappedNode = result.node
                dicek = false
            }
        }
        
    }
    
   func processNodeSelection(_ node: SCNNode) {
        if arrowX != nil && arrowY != nil && arrowZ != nil {
                updateArrowPositionsToMatchNode(node: node)
        } else {
            
            deselectNodeAndArrows()
            selectedNode = node
            parent.view.allowsCameraControl = false
            
            if let nodeName = selectedNode?.name, ["wall1", "wall2", "wall3", "wall4", "floor"].contains(nodeName) {
                let worldBoundingBox = selectedNode!.boundingBox
                let worldMin = selectedNode!.convertPosition(worldBoundingBox.min, to: nil)
                let worldMax = selectedNode!.convertPosition(worldBoundingBox.max, to: nil)
                
                let x = String(format: "%.2f", worldMax.x - worldMin.x)
                let y = String(format: "%.2f", worldMax.y - worldMin.y)
                let z = String(format: "%.2f", worldMax.z - worldMin.z)
                
                objectDimensionData.name = selectedNode!.name ?? "Unknown"
                print(selectedNode?.name)
                objectDimensionData.width = x
                objectDimensionData.height = y
                objectDimensionData.length = z
                
                print("Dimension \(x), \(y), \(z)")
                print(objectDimensionData.name)
                
            } else {
                let (minBounds, maxBounds) = node.boundingBox
                let midPoint = SCNVector3(
                    (maxBounds.x + minBounds.x) / 2,
                    (maxBounds.y + minBounds.y) / 2,
                    (maxBounds.z + minBounds.z) / 2
                )
                
                let worldBoundingBox = selectedNode!.boundingBox
                let worldMin = selectedNode!.convertPosition(worldBoundingBox.min, to: nil)
                let worldMax = selectedNode!.convertPosition(worldBoundingBox.max, to: nil)
                
                let x = String(format: "%.2f", worldMax.x - worldMin.x)
                let y = String(format: "%.2f", worldMax.y - worldMin.y)
                let z = String(format: "%.2f", worldMax.z - worldMin.z)
                
                objectDimensionData.name = selectedNode!.name ?? "Unknown"
                objectDimensionData.width = x
                objectDimensionData.height = y
                objectDimensionData.length = z
                
                print("Dimension \(x), \(y), \(z)")
                print(objectDimensionData.name)
                
                let xFloat = worldMax.x - worldMin.x
                let yFloat = worldMax.y - worldMin.y
                let zFloat = worldMax.z - worldMin.z
                
                arrowX = createArrowNode(axis: SCNVector3(1, 0, 0), color: .red, arrowName: "axisArrowX", X: xFloat, Y: yFloat, Z: zFloat)
                parent.roomSceneViewModel.arrowNode.append(arrowX!)
                arrowY = createArrowNode(axis: SCNVector3(0, 1, 0), color: .green, arrowName: "axisArrowY", X: xFloat, Y: yFloat, Z: zFloat)
                parent.roomSceneViewModel.arrowNode.append(arrowY!)
                arrowZ = createArrowNode(axis: SCNVector3(0, 0, 1), color: .blue, arrowName: "axisArrowZ", X: xFloat, Y: yFloat, Z: zFloat)
                parent.roomSceneViewModel.arrowNode.append(arrowZ!)
                     
                parent.scene?.rootNode.addChildNode(parent.roomSceneViewModel.arrowNode[0])
                parent.scene?.rootNode.addChildNode(parent.roomSceneViewModel.arrowNode[1])
                parent.scene?.rootNode.addChildNode(parent.roomSceneViewModel.arrowNode[2])
                
                parent.roomSceneViewModel.torusNode?.removeFromParentNode()
                parent.roomSceneViewModel.torusHighNode?.removeFromParentNode()
                
                updateArrowPositionsToMatchNode(node: node)
            }
            
        }
        
    }
    
    func deselectNodeAndArrows() {
        selectedNode?.childNodes.filter { $0.name?.hasPrefix("axisArrow") == true }
            .forEach { $0.removeFromParentNode() }
        parent.isEditMode = false
        objectDimensionData.reset()
        selectedNode = nil
        
        for childArrowNode in parent.roomSceneViewModel.arrowNode{
            childArrowNode.removeFromParentNode()
        }
        parent.roomSceneViewModel.arrowNode.removeAll()
        arrowX = nil
        arrowY = nil
        arrowZ = nil
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard !parent.isEditMode else {
            
            print("Pan detected")
            
            guard let selectedNode = selectedNode else {return}
            
            let translation = gestureRecognizer.translation(in: parent.view)
            print("translation \(translation)")
            
            let cameraNode = parent.view.pointOfView
            
            if gestureRecognizer.numberOfTouches == 1 {
                handleOneFingerPan(translation: translation, for: selectedNode, cameraNode: cameraNode!)
            }
            switch gestureRecognizer.state {
            case .began:
                lastPanTranslation = translation
            case .changed:
                lastPanTranslation = translation
            default:
                lastPanTranslation = .zero
            }
            return
        }
        
    }
    
    private func handleOneFingerPan(translation: CGPoint, for node: SCNNode, cameraNode: SCNNode) {
        let scaleFactor: Float = 0.01
        var translationDelta = SCNVector3(
            x: Float(translation.x - lastPanTranslation.x),
            y: Float(lastPanTranslation.y - translation.y),
            z: 0
        )

        let (angle, axis) = cameraNode.orientation.toAxisAngle()
        let rotationMatrix = SCNMatrix4MakeRotation(Float(angle), axis.x, axis.y, axis.z)

        translationDelta = SCNVector3MultMatrix4(translationDelta, rotationMatrix)

        var newPos = node.position
        switch selectedAxis {
        case "axisArrowX":
            newPos.z += translationDelta.z * scaleFactor
            
        case "axisArrowY":
            newPos.y += translationDelta.y * scaleFactor
        case "axisArrowZ":
            newPos.x += translationDelta.x * scaleFactor
        case "axisArrowRotation":
            // Assuming you want to rotate around the Y-axis
            let rotation = (Float(translation.x) - Float(lastPanTranslation.x)) * scaleFactor
            node.eulerAngles.y += rotation
        default:
            break
        }

        node.position = newPos
        updateArrowPositionsToMatchNode(node: node)
        lastPanTranslation = translation

    }
    
     func updateArrowPositionsToMatchNode(node: SCNNode) {
        // Make sure the arrows exist
        guard let arrowX = self.arrowX, let arrowY = self.arrowY, let arrowZ = self.arrowZ else {
            return
        }
        
        let worldPosition = node.presentation.worldPosition // Use presentation for smooth updates
        arrowX.worldPosition = worldPosition
        arrowY.worldPosition = worldPosition
        arrowZ.worldPosition = worldPosition
    }
    
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        parent.view.addGestureRecognizer(panGesture)
    }
    
    func removePanGesture() {
        if let panGesture = parent.view.gestureRecognizers?.first(where: { $0 is UIPanGestureRecognizer }) {
            parent.view.removeGestureRecognizer(panGesture)
            let _ = print("PAN GESTURE REMOVED")
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func createArrowNode(axis: SCNVector3, color: UIColor, arrowName: String, X: Float, Y: Float, Z: Float) -> SCNNode {
        let cylinder = SCNCylinder(radius: 0.01, height: 1.0)
        cylinder.radialSegmentCount = 12
        let cylinderMaterial = SCNMaterial()
        cylinderMaterial.diffuse.contents = color
        cylinderMaterial.transparency = 0
        cylinder.firstMaterial = cylinderMaterial

        let cone = SCNCone(topRadius: 0, bottomRadius: 0.07, height: 0.15)
        cone.radialSegmentCount = 12
        let coneMaterial = SCNMaterial()
        coneMaterial.diffuse.contents = color
//            coneMaterial.transparency = 0.7
        cone.firstMaterial = coneMaterial

        let cylinderNode = SCNNode(geometry: cylinder)
        let coneNode = SCNNode(geometry: cone)
        coneNode.position = SCNVector3(0, 0.5, 0) // Adjust based on cylinder height
//            cylinderNode.addChildNode(coneNode)
        
        // Define the total height of the arrow for positioning the torus
        let totalHeight = X / 2.0 // cylinder height + cone height
        let torusRadius = X // Adjust as necessary
       let torusThickness = 0.03 // Adjust as necessary

       // Create the torus as the rotation indicator
        let torus = SCNTorus(ringRadius: CGFloat(torusRadius), pipeRadius: torusThickness)
        torus.firstMaterial?.diffuse.contents = Color(.cyan)
       let torusNode = SCNNode(geometry: torus)
        torusNode.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, 0)
       torusNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)// Lay the torus flat

        
        // Rotate the arrow according to the axis
        if axis.x != 0 {
            cylinderNode.eulerAngles = SCNVector3(CGFloat.pi / 2, 0, 0)
            cylinderNode.name = "axisArrowX"
            coneNode.eulerAngles = SCNVector3(CGFloat.pi / 2, 0, 0)
            coneNode.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, X + 0.15)
            coneNode.name = "axisArrowX"
        } else if axis.y != 0 {
            cylinderNode.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
            cylinderNode.name = "axisArrowY"
            coneNode.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
            coneNode.position = SCNVector3(0, Y + 0.15, 0)
            coneNode.name = "axisArrowY"
        } else if axis.z != 0 {
            cylinderNode.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
            cylinderNode.name = "axisArrowZ"
            coneNode.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
            coneNode.position = SCNVector3(-0.15 - Z, Float(totalHeight) / 2 + 0.1, 0)
            coneNode.name = "axisArrowZ"
        }
        
        let parentNode = SCNNode()
//            parentNode.addChildNode(cylinderNode)
        parentNode.addChildNode(coneNode)
        parentNode.addChildNode(torusNode) // Add the torus node to the parent

        // Set the name for both the cylinder and cone
        cylinderNode.name = arrowName
        coneNode.name = arrowName
        torusNode.name = "axisArrowRotation" // Optionally, give the torus the same name

        // Set the name for the parent node
        parentNode.name = arrowName

        return parentNode
    }
    
    func createRotationPlane(axis: SCNVector3, color: UIColor) -> SCNNode {
        // Create a large plane for the outer ring
        let outerPlane = SCNTorus(ringRadius: 0.1, pipeRadius: 0.01)
        outerPlane.firstMaterial?.diffuse.contents = color
        outerPlane.firstMaterial?.isDoubleSided = true

        let rotationPlaneNode = SCNNode(geometry: outerPlane)

        // Rotate the plane to be perpendicular to the axis
        if axis.x != 0 {
            rotationPlaneNode.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
        } else if axis.y != 0 {
            rotationPlaneNode.eulerAngles = SCNVector3(CGFloat.pi / 2, 0, 0)
        } else if axis.z != 0 {
            rotationPlaneNode.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
        }

        return rotationPlaneNode
    }
    
    func SCNVector3MultMatrix4(_ vector: SCNVector3, _ matrix: SCNMatrix4) -> SCNVector3 {
        let x = vector.x * matrix.m11 + vector.y * matrix.m21 + vector.z * matrix.m31
        let y = vector.x * matrix.m12 + vector.y * matrix.m22 + vector.z * matrix.m32
        let z = vector.x * matrix.m13 + vector.y * matrix.m23 + vector.z * matrix.m33
        return SCNVector3(x, y, z)
    }
}
