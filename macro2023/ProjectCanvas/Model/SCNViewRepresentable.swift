//
//  SCNViewRepresentable.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 25/10/23.
//
import Foundation
import SwiftUI
import SceneKit
import simd

struct ScenekitView: UIViewRepresentable {
    typealias UIViewType = SCNView
    var scene: SCNScene
    var view = SCNView()
    @Binding var isEditMode: Bool
    @Binding var nodePositions: [String: SCNVector3]
    @Binding var nodeRotation: [String: SCNQuaternion]
    
    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = !isEditMode
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.allowsCameraControl = !isEditMode
        
    }
    
    func updateNodePositions() {
        scene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                nodePositions[name] = node.worldPosition
                print("\(node.name): \(node.worldPosition) - \(node.rotation)")
            }
        }
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
        private var initialNodePosition: SCNVector3?
        
        init(_ parent: ScenekitView) {
            self.parent = parent
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
            guard !parent.isEditMode else {
                let p = gestureRecognizer.location(in: parent.view)
                let hitResults = parent.view.hitTest(p, options: [:])
                
                if let result = hitResults.first {
                    selectedNode = result.node
                    parent.view.allowsCameraControl = false
                    let max = selectedNode!.boundingBox.max
                    let min = selectedNode!.boundingBox.min
                    let dimension = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
//                    print("\(selectedNode?.name) : \(dimension)")
                    addPanGesture()
                }
                return
            }
            
        }
        
        @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard !parent.isEditMode else {
                guard let selectedNode = selectedNode else { return }
                rotateNode(selectedNode)
                return
            }
        }
        
        @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
            guard !parent.isEditMode else {
                guard let selectedNode = selectedNode else {return}
                let translation = gestureRecognizer.translation(in: parent.view)
                
                if gestureRecognizer.numberOfTouches == 1 {
                    handleOneFingerPan(translation: translation, for: selectedNode)
                } else if gestureRecognizer.numberOfTouches == 2 {
                    handleTwoFingerPan(translation: translation, for: selectedNode)
                }
                
                lastPanTranslation = translation
                return
            }
        }
        
        private func handleOneFingerPan(translation: CGPoint, for node: SCNNode) {
            let scaleFactor: Float = 0.01
            let newPos = SCNVector3(
                node.position.x + Float(translation.x - lastPanTranslation.x) * scaleFactor,
                node.position.y - Float(translation.y - lastPanTranslation.y) * scaleFactor,
                node.position.z
            )
            node.position = newPos
            if let nodeName = node.name {
                parent.nodePositions[nodeName] = newPos
            }
        }
        
        private func handleTwoFingerPan(translation: CGPoint, for node: SCNNode) {
            let scaleFactor: Float = 0.01
            let newPos = SCNVector3(
                node.position.x,
                node.position.y,
                node.position.z - Float(translation.y - lastPanTranslation.y) * scaleFactor
            )
            node.position = newPos
            if let nodeName = node.name {
                parent.nodePositions[nodeName] = newPos
            }
        }
        
        private func rotateNode(_ node: SCNNode) {
//            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi/2, z: 0, duration: 0.2)
//               node.runAction(rotateAction) {
//                   if let nodeName = node.name {
//                       let rotation = node.rotation
//                       self.parent.nodeRotation[nodeName] = rotation
//                       print("ROTATE NODE -> \(nodeName) : \(self.parent.nodeRotation[nodeName])")
//                   }
//               }
            // Define the rotation axis and angle
           let rotationAxis = SCNVector3(0, 1, 0) // Y axis
           let rotationAngle = Float.pi / 2 // 90 degrees

           // Create a quaternion from the axis and angle
           let rotationQuaternion = SCNQuaternion(
               x: rotationAxis.x * sin(rotationAngle / 2),
               y: rotationAxis.y * sin(rotationAngle / 2),
               z: rotationAxis.z * sin(rotationAngle / 2),
               w: cos(rotationAngle / 2)
           )

           // Create the rotation action
           let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(rotationAngle), z: 0, duration: 0.2)

           // Run the rotation action
           node.runAction(rotateAction) {
               // After the rotation action completes
               if let nodeName = node.name {
                   // Combine the new rotation with the current rotation
                   let combinedOrientation = rotationQuaternion * node.orientation
                   
                   // Update the nodeRotation dictionary with the new combined rotation
                   self.parent.nodeRotation[nodeName] = combinedOrientation
                   print("ROTATE NODE -> \(nodeName) : \(self.parent.nodeRotation[nodeName])")
               }
           }
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
    }
}

func * (left: SCNQuaternion, right: SCNQuaternion) -> SCNQuaternion {
    let leftW = left.w, leftX = left.x, leftY = left.y, leftZ = left.z
    let rightW = right.w, rightX = right.x, rightY = right.y, rightZ = right.z
    
    return SCNQuaternion(
        x: leftW * rightX + leftX * rightW + leftY * rightZ - leftZ * rightY,
        y: leftW * rightY - leftX * rightZ + leftY * rightW + leftZ * rightX,
        z: leftW * rightZ + leftX * rightY - leftY * rightX + leftZ * rightW,
        w: leftW * rightW - leftX * rightX - leftY * rightY - leftZ * rightZ
    )
}
