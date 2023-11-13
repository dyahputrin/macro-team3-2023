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
    @Binding var roomWidth: Float
    typealias UIViewType = SCNView
    var view = SCNView()
    
    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = !isEditMode
        view.defaultCameraController.translateInCameraSpaceBy(x: 0, y: 1, z: (roomWidth))
        
//        if let camera = view.pointOfView?.camera {
//            camera.zFar = 10000
//        }
        
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
                arrowY?.opacity = 0.5
                arrowX?.opacity = 0.5
                arrowZ?.opacity = 0.5
                arrowRotation?.opacity = 0.5
                
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
//                let worldBoundingBox = selectedNode!.boundingBox
//                let worldMin = selectedNode!.convertPosition(worldBoundingBox.min, to: nil)
//                let worldMax = selectedNode!.convertPosition(worldBoundingBox.max, to: nil)
//                
//                let x = String(format: "%.2f", worldMax.x - worldMin.x)
//                let y = String(format: "%.2f", worldMax.y - worldMin.y)
//                let z = String(format: "%.2f", worldMax.z - worldMin.z)
//                
//                objectDimensionData.name = selectedNode!.name ?? "Unknown"
//                print(selectedNode?.name)
//                objectDimensionData.width = x
//                objectDimensionData.height = y
//                objectDimensionData.length = z
                
                let worldBoundingBox = selectedNode!.presentation.boundingBox
                let x = String(format: "%.2f", worldBoundingBox.max.x - worldBoundingBox.min.x)
                let y = String(format: "%.2f", worldBoundingBox.max.y - worldBoundingBox.min.y)
                let z = String(format: "%.2f", worldBoundingBox.max.z - worldBoundingBox.min.z)

                objectDimensionData.name = selectedNode!.name ?? "Unknown"
                objectDimensionData.width = x
                objectDimensionData.height = y
                objectDimensionData.length = z
                
                if let nodeName = selectedNode?.name, ["wall1", "wall2", "wall3", "wall4", "floor", "floorScene"].contains(nodeName) {
                    print("Dimension \(x), \(y), \(z)")
                    print(objectDimensionData.name)
                    
                } else {
                    let (minBounds, maxBounds) = node.boundingBox
                    let midPoint = SCNVector3(
                        (maxBounds.x + minBounds.x) / 2,
                        (maxBounds.y + minBounds.y) / 2,
                        (maxBounds.z + minBounds.z) / 2
                    )
                    
//                    let worldBoundingBox = selectedNode!.boundingBox
//                    let worldMin = selectedNode!.convertPosition(worldBoundingBox.min, to: nil)
//                    let worldMax = selectedNode!.convertPosition(worldBoundingBox.max, to: nil)
//                    
//                    let x = String(format: "%.2f", worldMax.x - worldMin.x)
//                    let y = String(format: "%.2f", worldMax.y - worldMin.y)
//                    let z = String(format: "%.2f", worldMax.z - worldMin.z)
//                    
//                    objectDimensionData.name = selectedNode!.name ?? "Unknown"
//                    objectDimensionData.width = x
//                    objectDimensionData.height = y
//                    objectDimensionData.length = z
                    
                    let worldBoundingBox = selectedNode!.presentation.boundingBox
                    let x = String(format: "%.2f", worldBoundingBox.max.x - worldBoundingBox.min.x)
                    let y = String(format: "%.2f", worldBoundingBox.max.y - worldBoundingBox.min.y)
                    let z = String(format: "%.2f", worldBoundingBox.max.z - worldBoundingBox.min.z)

                    objectDimensionData.name = selectedNode!.name ?? "Unknown"
                    objectDimensionData.width = x
                    objectDimensionData.height = y
                    objectDimensionData.length = z
                    
                    print("Dimension \(x), \(y), \(z)")
                    print(objectDimensionData.name)
                    
                    let xFloat = Float(x)
                    let yFloat = Float(y)
                    let zFloat = Float(z)
                    
//                    let xFloat = worldMax.x - worldMin.x
//                    let yFloat = worldMax.y - worldMin.y
//                    let zFloat = worldMax.z - worldMin.z
                    
                    arrowX = createArrowNode(axis: SCNVector3(1, 0, 0), color: .red, arrowName: "axisArrowX", X: xFloat ?? 0.0, Y: yFloat ?? 0.0, Z: zFloat ?? 0.0)
                    arrowY = createArrowNode(axis: SCNVector3(0, 1, 0), color: .green, arrowName: "axisArrowY", X: xFloat ?? 0.0, Y: yFloat ?? 0.0, Z: zFloat ?? 0.0)
                    arrowZ = createArrowNode(axis: SCNVector3(0, 0, 1), color: .blue, arrowName: "axisArrowZ", X: xFloat ?? 0.0, Y: yFloat ?? 0.0, Z: zFloat ?? 0.0)
                    
                    parent.scene?.rootNode.addChildNode(arrowX!)
                    parent.scene?.rootNode.addChildNode(arrowY!)
                    parent.scene?.rootNode.addChildNode(arrowZ!)
                    
                    updateArrowPositionsToMatchNode(node: node)
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
        
        func createArrowNode(axis: SCNVector3, color: UIColor, arrowName: String, X: Float, Y: Float, Z: Float) -> SCNNode {
            let cone = SCNCone(topRadius: 0, bottomRadius: 0.07, height: 0.15)
            cone.radialSegmentCount = 12
            let coneMaterial = SCNMaterial()
            coneMaterial.diffuse.contents = color
            cone.firstMaterial = coneMaterial
            
            let coneNode = SCNNode(geometry: cone)
            coneNode.position = SCNVector3(0, 0.5, 0)
            
            // Define the total height of the arrow for positioning the torus
            let totalHeight = X / 2.0
            let torusRadius = X
            let torusThickness = 0.03
            
            // Create the torus as the rotation indicator
            let torus = SCNTorus(ringRadius: CGFloat(torusRadius), pipeRadius: torusThickness)
            torus.firstMaterial?.diffuse.contents = UIColor(Color(.white))
            let torusNode = SCNNode(geometry: torus)
            torusNode.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, 0)
            torusNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)// Lay the torus flat
            
            
            // Rotate the arrow according to the axis
            if axis.x != 0 {
                coneNode.eulerAngles = SCNVector3(CGFloat.pi / 2, 0, 0)
                coneNode.position = SCNVector3(0, Float(totalHeight) / 2 + 0.1, X + 0.15)
                coneNode.name = "axisArrowX"
            } else if axis.y != 0 {
                coneNode.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
                coneNode.position = SCNVector3(0, Y + 0.15, 0)
                coneNode.name = "axisArrowY"
            } else if axis.z != 0 {
                coneNode.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
                coneNode.position = SCNVector3(-0.15 - Z, Float(totalHeight) / 2 + 0.1, 0)
                coneNode.name = "axisArrowZ"
            }
            
            let parentNode = SCNNode()
            parentNode.addChildNode(coneNode)
            parentNode.addChildNode(torusNode)
            torusNode.name = "axisArrowRotation"
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
    
}

extension SCNQuaternion {
    func toAxisAngle() -> (angle: CGFloat, axis: SCNVector3) {
        let angle = 2 * acos(w)
        let denom = sqrt(1 - w * w)
        let axis = denom > 0.0001 ? SCNVector3(x / denom, y / denom, z / denom) : SCNVector3(1, 0, 0)
        return (CGFloat(angle), axis)
    }
}

