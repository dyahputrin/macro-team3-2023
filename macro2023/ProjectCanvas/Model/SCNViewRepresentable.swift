//
//  SCNViewRepresentable.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 25/10/23.
//
import Foundation
import SwiftUI
import SceneKit

struct ScenekitView: UIViewRepresentable {
    @ObservedObject var objectDimensionData: ObjectDimensionData
    @Binding var scene: SCNScene?
    @Binding var isEditMode: Bool
    typealias UIViewType = SCNView
    var view = SCNView()
    var roomWidth: Float?
    
    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = !isEditMode
        view.defaultCameraController.translateInCameraSpaceBy(x: 0, y: -0.5, z: (roomWidth ?? 1) - 1)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.allowsCameraControl = !isEditMode
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func snapshot() -> UIImage? {
        return view.snapshot()
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: ScenekitView
        private var selectedNode: SCNNode?
        private var lastPanTranslation: CGPoint = .zero
        @State private var objectDimensionData: ObjectDimensionData
        var selectedAxis: String?
        var arrowX: SCNNode?
        var arrowY: SCNNode?
        var arrowZ: SCNNode?
        var arrowRotation: SCNNode?
        
        init(_ parent: ScenekitView) {
            self.parent = parent
            self.objectDimensionData = parent.objectDimensionData
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
            let p = gestureRecognizer.location(in: parent.view)
            let hitResults = parent.view.hitTest(p, options: [:])
            
            if hitResults.count == 0 {
                parent.isEditMode = false
                objectDimensionData.reset()
                deselectNodeAndArrows()
                return
            } else {
                parent.isEditMode = true
                if let result = hitResults.first(where: { $0.node.name?.hasPrefix("axisArrowY") == true }) {
                    arrowY?.opacity = 1.0
                    arrowX?.opacity = 0.5
                    arrowZ?.opacity = 0.5
                    arrowRotation?.opacity = 0.5
                    selectedAxis = result.node.name
                    print("result node name : \(result.node.name)")
                    addPanGesture()
                } else if let result = hitResults.first(where: { $0.node.name?.hasPrefix("axisArrowZ") == true }) {
                    arrowZ?.opacity = 1.0
                    arrowX?.opacity = 0.5
                    arrowY?.opacity = 0.5
                    arrowRotation?.opacity = 0.5
                    selectedAxis = result.node.name
                    print("result node name : \(result.node.name)")
                    addPanGesture()
                } else if let result = hitResults.first(where: { $0.node.name?.hasPrefix("axisArrowX") == true }) {
                    arrowX?.opacity = 1.0
                    arrowY?.opacity = 0.5
                    arrowZ?.opacity = 0.5
                    arrowRotation?.opacity = 0.5
                    selectedAxis = result.node.name
                    print("result node name : \(result.node.name)")
                    addPanGesture()
                } else if let result = hitResults.first(where: { $0.node.name?.hasPrefix("axisArrowRotation") == true }) {
                    arrowX?.opacity = 0.5
                    arrowY?.opacity = 0.5
                    arrowZ?.opacity = 0.5
                    arrowRotation?.opacity = 1.0
                    selectedAxis = result.node.name
                    print("result node name : \(result.node.name)")
                    addPanGesture()
                } else if let result = hitResults.first {
                    print("HIT TEST 2")
                    deselectNodeAndArrows()
                    processNodeSelection(result.node)
                    selectedAxis = nil
                }
                
            }
            
        }
        
        private func processNodeSelection(_ node: SCNNode) {
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
                    
                    arrowX = createArrowNode(axis: SCNVector3(1, 0, 0), color: .red, arrowName: "axisArrowX")
                    arrowY = createArrowNode(axis: SCNVector3(0, 1, 0), color: .green, arrowName: "axisArrowY")
                    arrowZ = createArrowNode(axis: SCNVector3(0, 0, 1), color: .blue, arrowName: "axisArrowZ")
                    
                    parent.scene?.rootNode.addChildNode(arrowX!)
                    parent.scene?.rootNode.addChildNode(arrowY!)
                    parent.scene?.rootNode.addChildNode(arrowZ!)
                    
                    updateArrowPositionsToMatchNode(node: node)
                    
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
                }
                
            }
            
        }
        
        private func deselectNodeAndArrows() {
            selectedNode?.childNodes.filter { $0.name?.hasPrefix("axisArrow") == true }
                .forEach { $0.removeFromParentNode() }
            parent.isEditMode = false
            objectDimensionData.reset()
            selectedNode = nil
            
            arrowX?.removeFromParentNode()
            arrowY?.removeFromParentNode()
            arrowZ?.removeFromParentNode()
            
            arrowX = nil
            arrowY = nil
            arrowZ = nil
        }
        
        @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
            guard !parent.isEditMode else {
//                print("Pan detected")
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
                let rotation = (Float(translation.x) - Float(lastPanTranslation.x)) * scaleFactor
                node.eulerAngles.y += rotation
            default:
                break
            }
            node.position = newPos
            updateArrowPositionsToMatchNode(node: node)
            lastPanTranslation = translation
            
        }
        
        private func updateArrowPositionsToMatchNode(node: SCNNode) {
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
        
        func createArrowNode(axis: SCNVector3, color: UIColor, arrowName: String) -> SCNNode {
            
            let cone = SCNCone(topRadius: 0, bottomRadius: 0.04, height: 0.1)
            cone.radialSegmentCount = 12
            let coneMaterial = SCNMaterial()
            coneMaterial.diffuse.contents = color
            cone.firstMaterial = coneMaterial
            
            let coneNode = SCNNode(geometry: cone)
            coneNode.position = SCNVector3(0, 0.5, 0) // Adjust based on cylinder height
            
            // Define the total height of the arrow for positioning the torus
            let totalHeight = (Double(objectDimensionData.width) ?? 0.1) / 2.0 
            let torusRadius = (Double(objectDimensionData.width) ?? 0.1) + 0.1
            let torusThickness = 0.02
            
            // Create the torus as the rotation indicator
            let torus = SCNTorus(ringRadius: torusRadius, pipeRadius: torusThickness)
            torus.firstMaterial?.diffuse.contents = UIColor(Color(.gray))
            arrowRotation = SCNNode(geometry: torus)
            arrowRotation?.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, 0)
            arrowRotation?.eulerAngles = SCNVector3(0, Float.pi / 2, 0)
            
            // Rotate the arrow according to the axis
            if axis.x != 0 {
                coneNode.eulerAngles = SCNVector3(CGFloat.pi / 2, 0, 0)
                coneNode.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, (Float(objectDimensionData.width) ?? 0.1) + 0.3)
                coneNode.name = "axisArrowX"
            } else if axis.y != 0 {
                coneNode.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
                coneNode.name = "axisArrowY"
            } else if axis.z != 0 {
                coneNode.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
                coneNode.position = SCNVector3((Float(objectDimensionData.width) ?? 0.1) - 0.5, Float(totalHeight) / 2 + 0.1, 0)
                coneNode.name = "axisArrowZ"
            }
            
            let parentNode = SCNNode()
//            coneNode.opacity = 0.5
//            arrowRotation?.opacity = 0.5
            parentNode.addChildNode(coneNode)
            parentNode.addChildNode(arrowRotation!) // Add the torus node to the parent
            arrowRotation?.name = "axisArrowRotation" // Optionally, give the torus the same name
            parentNode.name = arrowName
            
            return parentNode
        }
        
        func SCNVector3MultMatrix4(_ vector: SCNVector3, _ matrix: SCNMatrix4) -> SCNVector3 {
            let x = vector.x * matrix.m11 + vector.y * matrix.m21 + vector.z * matrix.m31
            let y = vector.x * matrix.m12 + vector.y * matrix.m22 + vector.z * matrix.m32
            let z = vector.x * matrix.m13 + vector.y * matrix.m23 + vector.z * matrix.m33
            return SCNVector3(x, y, z)
        }
    }
    
}

extension SCNQuaternion {
    func toAxisAngle() -> (angle: CGFloat, axis: SCNVector3) {
        let angle = 2 * acos(w)
        let denom = sqrt(1 - w * w)
        let axis = denom > 0.0001 ? SCNVector3(x / denom, y / denom, z / denom) : SCNVector3(1, 0, 0)
        return (CGFloat(angle), axis)
    }
}

